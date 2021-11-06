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
    private var ambientRenderer: AmbientRenderer
    private var ssaoTexture: MTLTexture
    init?(device: MTLDevice, renderingSize: CGSize, gBufferOutput: GPUSupply, ssaoTexture: MTLTexture) {
        guard let stencilTexture = gBufferOutput.stencil,
              let environmentRenderer = EnvironmentRenderer.make(device: device, drawableSize: renderingSize),
              let lightRenderer = LightPassRenderer.make(device: device,
                                                           inputTextures: gBufferOutput.color,
                                                           drawableSize: renderingSize),
              let ambientRenderer = AmbientRenderer.make(device: device,
                                                         inputTextures: gBufferOutput.color,
                                                         drawableSize: renderingSize)  else {
            return nil
        }
        offscreenRenderPassDescriptor = .lightenScene(device: device,
                                                      depthStencil: stencilTexture,
                                                      size: renderingSize)
        guard let outputTexture = offscreenRenderPassDescriptor.colorAttachments[0].texture else {
            return nil
        }
        self.ambientRenderer = ambientRenderer
        self.ssaoTexture = ssaoTexture
        self.environmentRenderer = environmentRenderer
        self.lightRenderer = lightRenderer
        self.io = GPUIO(input: GPUSupply(color: gBufferOutput.color + [ssaoTexture],
                                         stencil: gBufferOutput.stencil),
                        output: GPUSupply(color: [outputTexture]))
    }
    func draw(commandBuffer: inout MTLCommandBuffer,
              scene: inout GPUSceneDescription,
              bufferStore: inout BufferStore) {
        commandBuffer.pushDebugGroup("Omni Light Pass")
        guard var encoder = commandBuffer.makeRenderCommandEncoder(descriptor: offscreenRenderPassDescriptor) else {
            return
        }
        lightRenderer.draw(encoder: &encoder,
                           bufferStore: &bufferStore,
                           lightsCount: scene.omniLights.count,
                           scene: &scene)
        commandBuffer.popDebugGroup()
        commandBuffer.pushDebugGroup("Ambient Light Pass")
        ambientRenderer.draw(encoder: &encoder,
                             bufferStore: &bufferStore,
                             lightsCount: scene.ambientLights.count,
                             ssao: ssaoTexture,
                             scene: &scene)
        commandBuffer.popDebugGroup()
        commandBuffer.pushDebugGroup("Environment Map")
        environmentRenderer.draw(encoder: &encoder, scene: &scene)
        encoder.endEncoding()
        commandBuffer.popDebugGroup()
    }
}
