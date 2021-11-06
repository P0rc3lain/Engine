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
    private var ssaoRenderer: SsaoRenderer
    init?(device: MTLDevice,
          renderingSize: CGSize,
          prTexture: MTLTexture,
          nmTexture: MTLTexture) {
        guard let ssaoRenderer = SsaoRenderer.make(device: device,
                                                   prTexture: prTexture,
                                                   nmTexture: nmTexture,
                                                   drawableSize: renderingSize),
              let gaussTexture = device.makeTexture(descriptor: .ssaoColor(size: renderingSize)) else {
            return nil
        }
        self.ssaoRenderer = ssaoRenderer
        self.ssaoRenderPassDescriptor = .ssao(device: device, size: renderingSize)
        self.io = GPUIO(input: GPUSupply(color: [prTexture, nmTexture]),
                        output: GPUSupply(color: [gaussTexture]))
        self.gaussianBlur = MPSImageGaussianBlur(device: device, sigma: 1)
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
