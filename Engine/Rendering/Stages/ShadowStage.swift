//
//  Copyright © 2021 Mateusz Stompór. All rights reserved.
//

import Metal

struct ShadowStage: Stage {
    var io: GPUIO
    private var spotLightShadowRenderPassDescriptor: MTLRenderPassDescriptor
    private var spotLightShadowRenderer: SpotShadowRenderer
    init?(device: MTLDevice,
          spotShadowTextureSideSize: Float,
          spotLightsNumber: Int) {
        let size = CGSize(width: CGFloat(spotShadowTextureSideSize),
                          height: CGFloat(spotShadowTextureSideSize))
        self.spotLightShadowRenderPassDescriptor = .spotLightShadow(device: device,
                                                                    size: size,
                                                                    layers: spotLightsNumber)
        guard let textures = spotLightShadowRenderPassDescriptor.depthAttachment.texture,
              let spotLightShadowRenderer = SpotShadowRenderer.make(device: device,
                                                                    renderingSize: size) else {
            return nil
        }
        self.io = GPUIO(input: .empty,
                        output: GPUSupply(color: [], stencil: nil, depth: textures))
        self.spotLightShadowRenderer = spotLightShadowRenderer
    }
    mutating func draw(commandBuffer: inout MTLCommandBuffer,
                       scene: inout GPUSceneDescription,
                       bufferStore: inout BufferStore) {
        guard var encoder = commandBuffer.makeRenderCommandEncoder(descriptor: spotLightShadowRenderPassDescriptor) else {
            return
        }
        encoder.pushDebugGroup("Spot Light Shadow Pass")
        spotLightShadowRenderer.draw(encoder: &encoder, scene: &scene, dataStore: &bufferStore)
        encoder.endEncoding()
        commandBuffer.popDebugGroup()
    }
}
