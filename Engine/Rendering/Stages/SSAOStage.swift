//
//  Copyright © 2021 Mateusz Stompór. All rights reserved.
//

import Metal
import MetalPerformanceShaders

struct SSAOStage: Stage {
    var io: GPUIO
    private let gaussTexture: MTLTexture
    private let gaussianBlur: MPSImageGaussianBlur
    private var ssaoRenderPassDescriptor: MTLRenderPassDescriptor
    private var ssaoRenderer: SSAORenderer
    init?(device: MTLDevice,
          renderingSize: CGSize,
          prTexture: MTLTexture,
          nmTexture: MTLTexture,
          blurSigma: Float) {
        guard let ssaoRenderer = SSAORenderer.make(device: device,
                                                   prTexture: prTexture,
                                                   nmTexture: nmTexture,
                                                   drawableSize: renderingSize,
                                                   maxNoiseCount: 16,
                                                   maxSamplesCount: 64),
              let gaussTexture = device.makeTexture(descriptor: .ssaoColor(size: renderingSize)) else {
            return nil
        }
        self.ssaoRenderer = ssaoRenderer
        self.ssaoRenderPassDescriptor = .ssao(device: device, size: renderingSize)
        self.io = GPUIO(input: GPUSupply(color: [prTexture, nmTexture]),
                        output: GPUSupply(color: [gaussTexture]))
        self.gaussianBlur = MPSImageGaussianBlur(device: device,
                                                 sigma: blurSigma)
        self.gaussTexture = gaussTexture
    }
    mutating func draw(commandBuffer: inout MTLCommandBuffer, bufferStore: inout BufferStore) {
        commandBuffer.pushDebugGroup("SSAO Renderer Pass")
        guard var ssaoEncoder = commandBuffer.makeRenderCommandEncoder(descriptor: ssaoRenderPassDescriptor) else {
            return
        }
        ssaoRenderer.draw(encoder: &ssaoEncoder, bufferStore: &bufferStore)
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
