//
//  Copyright © 2021 Mateusz Stompór. All rights reserved.
//

import Foundation
import Metal

struct CombineStage: Stage {
    var io: GPUIO
    private var offscreenRenderPassDescriptor: MTLRenderPassDescriptor
    private var environmentRenderer: EnvironmentRenderer
    private var omniRenderer: OmniRenderer
    private var ambientRenderer: AmbientRenderer
    private var spotRenderer: SpotRenderer
    private var spotLightShadows: MTLTexture
    private var directionalRenderer: DirectionalRenderer
    private var ssaoTexture: MTLTexture
    init?(device: MTLDevice, renderingSize: CGSize, gBufferOutput: GPUSupply, ssaoTexture: MTLTexture, spotLightShadows: MTLTexture) {
        guard let stencilTexture = gBufferOutput.stencil,
              let environmentRenderer = EnvironmentRenderer.make(device: device, drawableSize: renderingSize),
              let omniRenderer = OmniRenderer.make(device: device,
                                                   inputTextures: gBufferOutput.color,
                                                   drawableSize: renderingSize),
              let ambientRenderer = AmbientRenderer.make(device: device,
                                                         inputTextures: gBufferOutput.color,
                                                         drawableSize: renderingSize),
              let directionalRenderer = DirectionalRenderer.make(device: device,
                                                                 inputTextures: gBufferOutput.color,
                                                                 drawableSize: renderingSize),
              let spotRenderer = SpotRenderer.make(device: device,
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
        self.ambientRenderer = ambientRenderer
        self.ssaoTexture = ssaoTexture
        self.environmentRenderer = environmentRenderer
        self.omniRenderer = omniRenderer
        self.spotRenderer = spotRenderer
        self.spotLightShadows = spotLightShadows
        self.directionalRenderer = directionalRenderer
        self.io = GPUIO(input: GPUSupply(color: gBufferOutput.color + [ssaoTexture],
                                         stencil: gBufferOutput.stencil),
                        output: GPUSupply(color: [outputTexture]))
    }
    func draw(commandBuffer: inout MTLCommandBuffer,
              scene: inout GPUSceneDescription,
              bufferStore: inout BufferStore) {
        commandBuffer.pushDebugGroup("Light Pass")
        guard var encoder = commandBuffer.makeRenderCommandEncoder(descriptor: offscreenRenderPassDescriptor) else {
            return
        }
        omniRenderer.draw(encoder: &encoder,
                          bufferStore: &bufferStore,
                          scene: &scene)
        ambientRenderer.draw(encoder: &encoder,
                             bufferStore: &bufferStore,
                             ssao: ssaoTexture,
                             scene: &scene)
        spotRenderer.draw(encoder: &encoder,
                          bufferStore: &bufferStore,
                          scene: &scene,
                          shadowMap: spotLightShadows)
        directionalRenderer.draw(encoder: &encoder,
                                 bufferStore: &bufferStore,
                                 scene: &scene)
        environmentRenderer.draw(encoder: &encoder, scene: &scene)
        encoder.endEncoding()
        commandBuffer.popDebugGroup()
    }
}
