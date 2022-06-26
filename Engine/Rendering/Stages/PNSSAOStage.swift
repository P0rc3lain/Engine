//
//  Copyright © 2021 Mateusz Stompór. All rights reserved.
//

import Metal
import MetalPerformanceShaders

struct PNSSAOStage: PNStage {
    var io: PNGPUIO
    private let gaussTexture: MTLTexture
    private let gaussianBlur: MPSImageGaussianBlur
    private var ssaoRenderPassDescriptor: MTLRenderPassDescriptor
    private var ssaoRenderer: PNRenderJob
    init?(device: MTLDevice,
          renderingSize: CGSize,
          prTexture: PNTextureProvider,
          nmTexture: PNTextureProvider,
          blurSigma: Float) {
        guard let ssaoRenderer = PNSSAOJob.make(device: device,
                                                prTexture: prTexture,
                                                nmTexture: nmTexture,
                                                drawableSize: renderingSize,
                                                maxNoiseCount: 64,
                                                maxSamplesCount: 64),
              let gaussTexture = device.makeTexture(descriptor: .ssaoC(size: renderingSize)) else {
            return nil
        }
        self.ssaoRenderer = ssaoRenderer
        self.ssaoRenderPassDescriptor = .ssao(device: device, size: renderingSize)
        self.io = PNGPUIO(input: PNGPUSupply(color: [prTexture, nmTexture]),
                          output: PNGPUSupply(color: [PNStaticTexture(gaussTexture)]))
        self.gaussianBlur = MPSImageGaussianBlur(device: device,
                                                 sigma: blurSigma)
        self.gaussTexture = gaussTexture
    }
    func draw(commandBuffer: MTLCommandBuffer, supply: PNFrameSupply) {
        commandBuffer.pushDebugGroup("SSAO Renderer Pass")
        guard let ssaoEncoder = commandBuffer.makeRenderCommandEncoder(descriptor: ssaoRenderPassDescriptor) else {
            return
        }
        ssaoRenderer.draw(encoder: ssaoEncoder, supply: supply)
        ssaoEncoder.endEncoding()
        commandBuffer.popDebugGroup()
        commandBuffer.pushDebugGroup("SSAO Blur Filter Pass")
        guard let ssaoTexture = ssaoRenderPassDescriptor.colorAttachments[0].texture else {
            return
        }
        gaussianBlur.encode(commandBuffer: commandBuffer,
                            sourceTexture: ssaoTexture,
                            destinationTexture: gaussTexture)
        commandBuffer.popDebugGroup()
    }
}
