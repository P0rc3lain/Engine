//
//  Copyright © 2021 Mateusz Stompór. All rights reserved.
//

import Metal

struct PNShadowStage: PNStage {
    var io: PNGPUIO
    private var omniShadowRPD: MTLRenderPassDescriptor
    private var spotShadowRPD: MTLRenderPassDescriptor
    private var directionalShadowRPD: MTLRenderPassDescriptor
    private var omniShadowJob: PNOmniShadowJob
    private var spotShadowJob: PNSpotShadowJob
    private var directionalShadowJob: PNDirectionalShadowJob
    init?(device: MTLDevice,
          omniShadowTextureSideSize: Float,
          spotShadowTextureSideSize: Float,
          directionalShadowTextureSideSize: Float,
          spotLightsNumber: Int,
          omniLightsNumber: Int,
          directionalLightsNumber: Int) {
        let spotRenderingSize = CGSize(side: CGFloat(spotShadowTextureSideSize))
        let omniRenderingSize = CGSize(side: CGFloat(omniShadowTextureSideSize))
        let directionalRenderingSize = CGSize(side: CGFloat(directionalShadowTextureSideSize))
        spotShadowRPD = .spotLightShadow(device: device,
                                         size: spotRenderingSize,
                                         layers: spotLightsNumber)
        omniShadowRPD = .omniLightShadow(device: device,
                                         size: omniRenderingSize,
                                         layers: omniLightsNumber)
        directionalShadowRPD = .directionalLightShadow(device: device,
                                                       size: directionalRenderingSize,
                                                       layers: directionalLightsNumber)
        guard let spotLightTextures = spotShadowRPD.depthAttachment.texture,
              let omniLightTextures = omniShadowRPD.depthAttachment.texture,
              let directionalLightTextures = directionalShadowRPD.depthAttachment.texture,
              let spotLightShadowJob = PNSpotShadowJob.make(device: device,
                                                            renderingSize: spotRenderingSize),
              let omniLightShadowJob = PNOmniShadowJob.make(device: device,
                                                            renderingSize: omniRenderingSize),
              let directionalLightShadowJob = PNDirectionalShadowJob.make(device: device,
                                                                          renderingSize: directionalRenderingSize) else {
            return nil
        }
        self.io = PNGPUIO(input: .empty,
                          output: PNGPUSupply(depth: [spotLightTextures, omniLightTextures, directionalLightTextures]))
        self.spotShadowJob = spotLightShadowJob
        self.omniShadowJob = omniLightShadowJob
        self.directionalShadowJob = directionalLightShadowJob
    }
    func draw(commandBuffer: MTLCommandBuffer, supply: PNFrameSupply) {
        if !supply.scene.spotLights.isEmpty {
            commandBuffer.pushDebugGroup("Spot Light Shadow Pass")
            guard let encoder = commandBuffer.makeRenderCommandEncoder(descriptor: spotShadowRPD) else {
                return
            }
            spotShadowJob.draw(encoder: encoder, supply: supply)
            encoder.endEncoding()
            commandBuffer.popDebugGroup()
        }
        if !supply.scene.omniLights.isEmpty {
            commandBuffer.pushDebugGroup("Omni Light Shadow Pass")
            guard let encoder = commandBuffer.makeRenderCommandEncoder(descriptor: omniShadowRPD) else {
                return
            }
            omniShadowJob.draw(encoder: encoder, supply: supply)
            encoder.endEncoding()
            commandBuffer.popDebugGroup()
        }
        if !supply.scene.directionalLights.isEmpty {
            commandBuffer.pushDebugGroup("Directional Light Shadow Pass")
            guard let encoder = commandBuffer.makeRenderCommandEncoder(descriptor: directionalShadowRPD) else {
                return
            }
            directionalShadowJob.draw(encoder: encoder, supply: supply)
            encoder.endEncoding()
            commandBuffer.popDebugGroup()
        }
    }
}
