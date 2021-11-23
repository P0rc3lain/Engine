//
//  Copyright © 2021 Mateusz Stompór. All rights reserved.
//

import Foundation
import Metal

struct CombineStage: Stage {
    var io: PNGPUIO
    private var renderPassDescriptor: MTLRenderPassDescriptor
    private var environmentRenderer: EnvironmentRenderer
    private var omniRenderer: OmniRenderer
    private var ambientRenderer: AmbientRenderer
    private var spotRenderer: SpotRenderer
    private var spotLightShadows: MTLTexture
    private var pointLightsShadows: MTLTexture
    private var directionalRenderer: DirectionalRenderer
    private var ssaoTexture: MTLTexture
    init?(device: MTLDevice,
          renderingSize: CGSize,
          gBufferOutput: PNGPUSupply,
          ssaoTexture: MTLTexture,
          spotLightShadows: MTLTexture,
          pointLightsShadows: MTLTexture) {
        guard let environmentRenderer = EnvironmentRenderer.make(device: device,
                                                                 drawableSize: renderingSize),
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
        renderPassDescriptor = .lightenScene(device: device,
                                             depthStencil: gBufferOutput.stencil[0],
                                             size: renderingSize)
        guard let outputTexture = renderPassDescriptor.colorAttachments[0].texture else {
            return nil
        }
        self.ambientRenderer = ambientRenderer
        self.ssaoTexture = ssaoTexture
        self.environmentRenderer = environmentRenderer
        self.omniRenderer = omniRenderer
        self.spotRenderer = spotRenderer
        self.spotLightShadows = spotLightShadows
        self.directionalRenderer = directionalRenderer
        self.pointLightsShadows = pointLightsShadows
        self.io = PNGPUIO(input: PNGPUSupply(color: gBufferOutput.color + [ssaoTexture],
                                             stencil: gBufferOutput.stencil),
                          output: PNGPUSupply(color: [outputTexture]))
    }
    func draw(commandBuffer: inout MTLCommandBuffer,
              scene: inout PNSceneDescription,
              bufferStore: inout BufferStore) {
        commandBuffer.pushDebugGroup("Light Pass")
        guard var encoder = commandBuffer.makeRenderCommandEncoder(descriptor: renderPassDescriptor) else {
            return
        }
        omniRenderer.draw(encoder: &encoder,
                          bufferStore: &bufferStore,
                          scene: &scene,
                          shadowMaps: pointLightsShadows)
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
        environmentRenderer.draw(encoder: &encoder,
                                 scene: &scene,
                                 bufferStore: &bufferStore)
        encoder.endEncoding()
        commandBuffer.popDebugGroup()
    }
}
