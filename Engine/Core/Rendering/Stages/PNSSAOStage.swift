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
          prTexture: PNTextureProvider,
          nmTexture: PNTextureProvider,
          blurSigma: Float) {
        guard let ssaoTexture = device.makeTextureSSAOC(size: renderingSize),
              let ssaoKernel = PNSSAOJob.make(device: device,
                                              prTexture: prTexture,
                                              nmTexture: nmTexture,
                                              outputTexture: PNStaticTexture(ssaoTexture)),
              let gaussTexture = device.makeTexture(descriptor: .ssaoC(size: renderingSize)) else {
            return nil
        }
        self.ssaoTexture = ssaoTexture
        self.ssaoKernel = ssaoKernel
        self.io = PNGPUIO(input: PNGPUSupply(color: [prTexture, nmTexture]),
                          output: PNGPUSupply(color: [PNStaticTexture(gaussTexture)]))
        self.gaussianBlur = MPSImageGaussianBlur(device: device, sigma: blurSigma)
        self.gaussTexture = gaussTexture
    }
    func draw(commandQueue: MTLCommandQueue, supply: PNFrameSupply) {
        guard let commandBuffer = commandQueue.makeCommandBuffer(),
              let ssaoEncoder = commandBuffer.makeComputeCommandEncoder() else {
            return
        }
        commandBuffer.label = "SSAO"
        commandBuffer.pushDebugGroup("SSAO Kernel")
        ssaoKernel.compute(encoder: ssaoEncoder, supply: supply)
        ssaoEncoder.endEncoding()
        commandBuffer.popDebugGroup()
        commandBuffer.pushDebugGroup("SSAO Blur Filter")
        gaussianBlur.encode(commandBuffer: commandBuffer,
                            sourceTexture: ssaoTexture,
                            destinationTexture: gaussTexture)
        commandBuffer.popDebugGroup()
        commandBuffer.commit()
    }
}
