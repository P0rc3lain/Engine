//
//  Copyright © 2025 Mateusz Stompór. All rights reserved.
//

import Metal

class PNSpotShadowStage: PNStage {
    var io: PNGPUIO
    private let device: MTLDevice
    private var spotShadowRPD: MTLRenderPassDescriptor
    private var spotRenderingTexture: PNDynamicTexture
    private var spotShadowJob: PNSpotShadowJob
    private let renderingSize: PNDefaults.PNShadowSize
    init?(device: MTLDevice,
          shadowTextureSize: PNDefaults.PNShadowSize) {
        self.renderingSize = shadowTextureSize
        spotRenderingTexture = PNIDynamicTexture(device: device)
        spotShadowRPD = .spotLightShadow(device: device,
                                         texture: spotRenderingTexture.texture)
        self.device = device
        guard let spotLightShadowJob = PNSpotShadowJob.make(device: device) else {
            return nil
        }
        self.io = PNGPUIO(input: .empty,
                          output: PNGPUSupply(depth: [spotRenderingTexture]))
        self.spotShadowJob = spotLightShadowJob
    }
    func updateTextures(supply: PNFrameSupply) -> Bool {
        let spotCount = supply.scene.spotLights.count
        let spotDescriptor: MTLTextureDescriptor? = spotCount > 0 ? .spotShadowDS(size: renderingSize.spot, lightsCount: spotCount) : nil
        let spotUpdated = spotRenderingTexture.updateDescriptor(descriptor: spotDescriptor)
        return spotUpdated
    }
    func draw(commandBuffer: MTLCommandBuffer, supply: PNFrameSupply) {
        if updateTextures(supply: supply) {
            spotShadowRPD = .spotLightShadow(device: device,
                                             texture: spotRenderingTexture.texture)
        }
        if supply.scene.spotLights.isEmpty {
            return
        }
        if !supply.scene.spotLights.isEmpty,
           let encoder = commandBuffer.makeRenderCommandEncoder(descriptor: spotShadowRPD) {
            spotShadowJob.draw(encoder: encoder, supply: supply)
            encoder.endEncoding()
        }
    }
}
