//
//  Copyright © 2021 Mateusz Stompór. All rights reserved.
//

import Metal

struct PNShadowStage: PNStage {
    var io: PNGPUIO
    private var omniLightShadowRenderPassDescriptor: MTLRenderPassDescriptor
    private var spotLightShadowRenderPassDescriptor: MTLRenderPassDescriptor
    private var directionalLightShadowRenderPassDescriptor: MTLRenderPassDescriptor
    private var omniLightShadowJob: PNOmniShadowJob
    private var spotLightShadowJob: PNSpotShadowJob
    private var directionalLightShadowJob: PNDirectionalShadowJob
    init?(device: MTLDevice,
          spotShadowTextureSideSize: Float,
          spotLightsNumber: Int,
          omniLightsNumber: Int,
          directionalLightsNumber: Int) {
        let size = CGSize(width: CGFloat(spotShadowTextureSideSize),
                          height: CGFloat(spotShadowTextureSideSize))
        spotLightShadowRenderPassDescriptor = .spotLightShadow(device: device,
                                                               size: size,
                                                               layers: spotLightsNumber)
        omniLightShadowRenderPassDescriptor = .omniLightShadow(device: device,
                                                               size: size,
                                                               layers: omniLightsNumber)
        directionalLightShadowRenderPassDescriptor = .directionalLightShadow(device: device,
                                                                             size: size,
                                                                             layers: directionalLightsNumber)
        guard let spotLightTextures = spotLightShadowRenderPassDescriptor.depthAttachment.texture,
              let omniLightTextures = omniLightShadowRenderPassDescriptor.depthAttachment.texture,
              let directionalLightTextures = directionalLightShadowRenderPassDescriptor.depthAttachment.texture,
              let spotLightShadowJob = PNSpotShadowJob.make(device: device,
                                                            renderingSize: size),
              let omniLightShadowJob = PNOmniShadowJob.make(device: device,
                                                            renderingSize: size),
              let directionalLightShadowJob = PNDirectionalShadowJob.make(device: device,
                                                                          renderingSize: size) else {
            return nil
        }
        self.io = PNGPUIO(input: .empty,
                          output: PNGPUSupply(depth: [spotLightTextures, omniLightTextures, directionalLightTextures]))
        self.spotLightShadowJob = spotLightShadowJob
        self.omniLightShadowJob = omniLightShadowJob
        self.directionalLightShadowJob = directionalLightShadowJob
    }
    func draw(commandBuffer: MTLCommandBuffer, supply: PNFrameSupply) {
        if !supply.scene.spotLights.isEmpty {
            commandBuffer.pushDebugGroup("Spot Light Shadow Pass")
            guard let encoder = commandBuffer.makeRenderCommandEncoder(descriptor: spotLightShadowRenderPassDescriptor) else {
                return
            }
            spotLightShadowJob.draw(encoder: encoder, supply: supply)
            encoder.endEncoding()
            commandBuffer.popDebugGroup()
        }
        if !supply.scene.omniLights.isEmpty {
            commandBuffer.pushDebugGroup("Omni Light Shadow Pass")
            guard let encoder = commandBuffer.makeRenderCommandEncoder(descriptor: omniLightShadowRenderPassDescriptor) else {
                return
            }
            omniLightShadowJob.draw(encoder: encoder, supply: supply)
            encoder.endEncoding()
            commandBuffer.popDebugGroup()
        }
        if !supply.scene.directionalLights.isEmpty {
            commandBuffer.pushDebugGroup("Directional Light Shadow Pass")
            guard let encoder = commandBuffer.makeRenderCommandEncoder(descriptor: directionalLightShadowRenderPassDescriptor) else {
                return
            }
            directionalLightShadowJob.draw(encoder: encoder, supply: supply)
            encoder.endEncoding()
            commandBuffer.popDebugGroup()
        }
    }
}
