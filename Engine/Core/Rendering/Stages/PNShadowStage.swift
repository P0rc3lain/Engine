//
//  Copyright © 2021 Mateusz Stompór. All rights reserved.
//

import Metal

class PNShadowStage: PNStage {
    var io: PNGPUIO
    private let device: MTLDevice
    private var omniShadowRPD: MTLRenderPassDescriptor
    private var spotShadowRPD: MTLRenderPassDescriptor
    private var directionalShadowRPD: MTLRenderPassDescriptor
    private var spotRenderingTexture: PNDynamicTexture
    private var omniRenderingTexture: PNDynamicTexture
    private var directionalRenderingTexture: PNDynamicTexture
    private var omniShadowJob: PNOmniShadowJob
    private var spotShadowJob: PNSpotShadowJob
    private let renderingSize: PNDefaults.PNShadowSize
    private var directionalShadowJob: PNDirectionalShadowJob
    init?(device: MTLDevice,
          shadowTextureSize: PNDefaults.PNShadowSize) {
        self.renderingSize = shadowTextureSize
        spotRenderingTexture = PNIDynamicTexture(device: device)
        omniRenderingTexture = PNIDynamicTexture(device: device)
        directionalRenderingTexture = PNIDynamicTexture(device: device)
        spotShadowRPD = .spotLightShadow(device: device,
                                         texture: spotRenderingTexture.texture)
        omniShadowRPD = .omniLightShadow(device: device,
                                         texture: omniRenderingTexture.texture)
        directionalShadowRPD = .directionalLightShadow(device: device,
                                                       texture: directionalRenderingTexture.texture)
        self.device = device
        guard let spotLightShadowJob = PNSpotShadowJob.make(device: device),
              let omniLightShadowJob = PNOmniShadowJob.make(device: device),
              let directionalLightShadowJob = PNDirectionalShadowJob.make(device: device) else {
            return nil
        }
        self.io = PNGPUIO(input: .empty,
                          output: PNGPUSupply(depth: [spotRenderingTexture, omniRenderingTexture, directionalRenderingTexture]))
        self.spotShadowJob = spotLightShadowJob
        self.omniShadowJob = omniLightShadowJob
        self.directionalShadowJob = directionalLightShadowJob
    }
    func updateTextures(supply: PNFrameSupply) -> Bool {
        let spotCount = supply.scene.spotLights.count
        let spotDescriptor: MTLTextureDescriptor? = spotCount > 0 ? .spotShadowDS(size: renderingSize.spot, lightsCount: spotCount) : nil
        let omniCount = supply.scene.omniLights.count
        let omniDescriptor: MTLTextureDescriptor? = omniCount > 0 ? .omniShadowDS(size: renderingSize.omni, lightsCount: omniCount) : nil
        let directionalCount = supply.scene.directionalLights.count
        let directionalDescriptor: MTLTextureDescriptor? = directionalCount > 0 ? .directionalShadowDS(size: renderingSize.directional,
                                                                                                       lightsCount: directionalCount) : nil
        let spotUpdated = spotRenderingTexture.updateDescriptor(descriptor: spotDescriptor)
        let omniUpdated = omniRenderingTexture.updateDescriptor(descriptor: omniDescriptor)
        let directionalUpdated = directionalRenderingTexture.updateDescriptor(descriptor: directionalDescriptor)
        return spotUpdated || omniUpdated || directionalUpdated
    }
    func draw(commandQueue: MTLCommandQueue, supply: PNFrameSupply) {
        if updateTextures(supply: supply) {
            spotShadowRPD = .spotLightShadow(device: device,
                                             texture: spotRenderingTexture.texture)
            omniShadowRPD = .omniLightShadow(device: device,
                                             texture: omniRenderingTexture.texture)
            directionalShadowRPD = .directionalLightShadow(device: device,
                                                           texture: directionalRenderingTexture.texture)
        }
        if !supply.scene.spotLights.isEmpty,
           let commandBuffer = commandQueue.makeCommandBuffer() {
            commandBuffer.label = "Spot Light Shadow Pass"
            guard let encoder = commandBuffer.makeRenderCommandEncoder(descriptor: spotShadowRPD) else {
                return
            }
            spotShadowJob.draw(encoder: encoder, supply: supply)
            encoder.endEncoding()
            commandBuffer.commit()
        }
        if !supply.scene.omniLights.isEmpty,
           let commandBuffer = commandQueue.makeCommandBuffer() {
            commandBuffer.label = "Omni Light Shadow Pass"
            guard let encoder = commandBuffer.makeRenderCommandEncoder(descriptor: omniShadowRPD) else {
                return
            }
            omniShadowJob.draw(encoder: encoder, supply: supply)
            encoder.endEncoding()
            commandBuffer.commit()
        }
        if !supply.scene.directionalLights.isEmpty,
           let commandBuffer = commandQueue.makeCommandBuffer() {
            commandBuffer.label = "Directional Light Shadow Pass"
            guard let encoder = commandBuffer.makeRenderCommandEncoder(descriptor: directionalShadowRPD) else {
                return
            }
            directionalShadowJob.draw(encoder: encoder, supply: supply)
            encoder.endEncoding()
            commandBuffer.commit()
        }
    }
}
