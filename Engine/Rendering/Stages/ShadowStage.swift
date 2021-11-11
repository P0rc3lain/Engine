//
//  Copyright © 2021 Mateusz Stompór. All rights reserved.
//

import Metal

struct ShadowStage: Stage {
    var io: GPUIO
    private var omniLightShadowRenderPassDescriptor: MTLRenderPassDescriptor
    private var spotLightShadowRenderPassDescriptor: MTLRenderPassDescriptor
    private var spotLightShadowRenderer: SpotShadowRenderer
    private var omniLightShadowRenderer: OmniShadowRenderer
    init?(device: MTLDevice,
          spotShadowTextureSideSize: Float,
          spotLightsNumber: Int,
          omniLightsNumber: Int) {
        let size = CGSize(width: CGFloat(spotShadowTextureSideSize),
                          height: CGFloat(spotShadowTextureSideSize))
        self.spotLightShadowRenderPassDescriptor = .spotLightShadow(device: device,
                                                                    size: size,
                                                                    layers: spotLightsNumber)
        self.omniLightShadowRenderPassDescriptor = .omniLightShadow(device: device,
                                                                    size: size,
                                                                    layers: omniLightsNumber)
        guard let spotLightTextures = spotLightShadowRenderPassDescriptor.depthAttachment.texture,
              let omniLightTextures = omniLightShadowRenderPassDescriptor.depthAttachment.texture,
              let spotLightShadowRenderer = SpotShadowRenderer.make(device: device,
                                                                    renderingSize: size),
              let omniLightShadowRenderer = OmniShadowRenderer.make(device: device,
                                                                    renderingSize: size) else {
            return nil
        }
        self.io = GPUIO(input: .empty,
                        output: GPUSupply(color: [], stencil: [], depth: [spotLightTextures, omniLightTextures]))
        self.spotLightShadowRenderer = spotLightShadowRenderer
        self.omniLightShadowRenderer = omniLightShadowRenderer
    }
    mutating func draw(commandBuffer: inout MTLCommandBuffer,
                       scene: inout GPUSceneDescription,
                       bufferStore: inout BufferStore) {
        if !scene.spotLights.isEmpty {
            guard var spotEncoder = commandBuffer.makeRenderCommandEncoder(descriptor: spotLightShadowRenderPassDescriptor) else {
                return
            }
            spotEncoder.pushDebugGroup("Spot Light Shadow Pass")
            spotLightShadowRenderer.draw(encoder: &spotEncoder, scene: &scene, dataStore: &bufferStore)
            spotEncoder.endEncoding()
            commandBuffer.popDebugGroup()
        }
        if !scene.omniLights.isEmpty {
            guard var omniEncoder = commandBuffer.makeRenderCommandEncoder(descriptor: omniLightShadowRenderPassDescriptor) else {
                return
            }
            omniEncoder.pushDebugGroup("Omni Light Shadow Pass")
            omniLightShadowRenderer.draw(encoder: &omniEncoder, scene: &scene, dataStore: &bufferStore)
            omniEncoder.endEncoding()
        }
    }
}