//
//  Copyright © 2021 Mateusz Stompór. All rights reserved.
//

import Foundation
import Metal

struct CombineStage: Stage {
    var io: GPUIO
    private var offscreenRenderPassDescriptor: MTLRenderPassDescriptor
    private var environmentRenderer: EnvironmentRenderer
    private var lightRenderer: LightPassRenderer
    private var ssaoTexture: MTLTexture
    init?(device: MTLDevice, renderingSize: CGSize, gBufferOutput: GPUSupply, ssaoTexture: MTLTexture) {
        guard let stencilTexture = gBufferOutput.stencil,
              let environmentRenderer = EnvironmentRenderer.make(device: device, drawableSize: renderingSize),
              let lightRenderer = LightPassRenderer.make(device: device,
                                                           inputTextures: gBufferOutput.color,
                                                           drawableSize: renderingSize) else {
            return nil
        }
        offscreenRenderPassDescriptor = .lightenScene(device: device,
                                                      depthStencil: stencilTexture,
                                                      size: renderingSize)
        guard let outputTexture = offscreenRenderPassDescriptor.colorAttachments[0].texture else {
            return nil
        }
        self.ssaoTexture = ssaoTexture
        self.environmentRenderer = environmentRenderer
        self.lightRenderer = lightRenderer
        self.io = GPUIO(input: GPUSupply(color: gBufferOutput.color + [ssaoTexture],
                                         stencil: gBufferOutput.stencil),
                        output: GPUSupply(color: [outputTexture]))
    }
    func draw(commandBuffer: inout MTLCommandBuffer, scene: inout GPUSceneDescription, bufferStore: inout BufferStore) {
        commandBuffer.pushDebugGroup("Omni Light Pass")
        guard var lightEncoder = commandBuffer.makeRenderCommandEncoder(descriptor: offscreenRenderPassDescriptor) else {
            return
        }
        lightRenderer.draw(encoder: &lightEncoder,
                           bufferStore: &bufferStore,
                           lightsCount: scene.lights.count,
                           ssao: ssaoTexture)
        commandBuffer.popDebugGroup()
        commandBuffer.pushDebugGroup("Environment Map")
        environmentRenderer.draw(encoder: &lightEncoder, scene: &scene)
        lightEncoder.endEncoding()
        commandBuffer.popDebugGroup()
    }
}
