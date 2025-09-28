//
//  Copyright © 2021 Mateusz Stompór. All rights reserved.
//

import Metal
import MetalPerformanceShaders

struct PNSSAOStage: PNStage {
    var io: PNGPUIO
    private let gaussTexture: MTLTexture
    private let ssaoTexture: MTLTexture
    private let gaussianBlur: MPSImageGaussianBlur
    private var ssaoKernel: PNSSAOJob
    init?(device: MTLDevice,
          renderingSize: CGSize,
          scaleSize: Float,
          prTexture: PNTextureProvider,
          nmTexture: PNTextureProvider,
          blurSigma: Float) {

        let ssaoTexturesSize = CGSize(width: renderingSize.width * CGFloat(scaleSize),
                                      height: renderingSize.height * CGFloat(scaleSize))
        guard let ssaoTexture = device.makeTextureSSAOC(size: ssaoTexturesSize),
              let ssaoKernel = PNSSAOJob.make(device: device,
                                              prTexture: prTexture,
                                              nmTexture: nmTexture,
                                              outputTexture: PNStaticTexture(ssaoTexture)),
              let gaussTexture = device.makeTexture(descriptor: .ssaoC(size: ssaoTexturesSize)) else {
            return nil
        }
        self.ssaoTexture = ssaoTexture
        self.ssaoKernel = ssaoKernel
        self.io = PNGPUIO(input: PNGPUSupply(color: [prTexture, nmTexture]),
                          output: PNGPUSupply(color: [PNStaticTexture(gaussTexture)]))
        self.gaussianBlur = MPSImageGaussianBlur(device: device, sigma: blurSigma)
        self.gaussTexture = gaussTexture
    }
    func draw(commandBuffer: MTLCommandBuffer, supply: PNFrameSupply) {
        guard let ssaoEncoder = commandBuffer.makeComputeCommandEncoder() else {
            return
        }
        ssaoKernel.compute(encoder: ssaoEncoder, supply: supply)
        ssaoEncoder.endEncoding()
        gaussianBlur.encode(commandBuffer: commandBuffer,
                            sourceTexture: ssaoTexture,
                            destinationTexture: gaussTexture)
    }
}
