//
//  Copyright © 2021 Mateusz Stompór. All rights reserved.
//

import Metal

struct PNShadowStage: PNStage {
    var io: PNGPUIO
    private var omniLightShadowRenderPassDescriptor: MTLRenderPassDescriptor
    private var spotLightShadowRenderPassDescriptor: MTLRenderPassDescriptor
    private var omniLightShadowJob: PNOmniShadowJob
    private var spotLightShadowJob: PNSpotShadowJob
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
              let spotLightShadowJob = PNSpotShadowJob.make(device: device,
                                                            renderingSize: size),
              let omniLightShadowJob = PNOmniShadowJob.make(device: device,
                                                            renderingSize: size) else {
            return nil
        }
        self.io = PNGPUIO(input: .empty,
                          output: PNGPUSupply(depth: [spotLightTextures, omniLightTextures]))
        self.spotLightShadowJob = spotLightShadowJob
        self.omniLightShadowJob = omniLightShadowJob
    }
    func draw(commandBuffer: MTLCommandBuffer, supply: PNFrameSupply) {
        if !supply.scene.spotLights.isEmpty {
            guard let spotEncoder = commandBuffer.makeRenderCommandEncoder(descriptor: spotLightShadowRenderPassDescriptor) else {
                return
            }
            spotEncoder.pushDebugGroup("Spot Light Shadow Pass")
            spotLightShadowJob.draw(encoder: spotEncoder, supply: supply)
            spotEncoder.endEncoding()
            commandBuffer.popDebugGroup()
        }
        if !supply.scene.omniLights.isEmpty {
            guard let omniEncoder = commandBuffer.makeRenderCommandEncoder(descriptor: omniLightShadowRenderPassDescriptor) else {
                return
            }
            omniEncoder.pushDebugGroup("Omni Light Shadow Pass")
            omniLightShadowJob.draw(encoder: omniEncoder, supply: supply)
            omniEncoder.endEncoding()
        }
    }
}
