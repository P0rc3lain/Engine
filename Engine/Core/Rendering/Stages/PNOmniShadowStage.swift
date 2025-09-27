//
//  Copyright © 2025 Mateusz Stompór. All rights reserved.
//

import Metal

class PNOmniShadowStage: PNStage {
    var io: PNGPUIO
    private let device: MTLDevice
    private var omniShadowRPD: MTLRenderPassDescriptor
    private var omniRenderingTexture: PNDynamicTexture
    private var omniShadowJob: PNOmniShadowJob
    private let renderingSize: PNDefaults.PNShadowSize
    init?(device: MTLDevice,
          shadowTextureSize: PNDefaults.PNShadowSize) {
        guard let omniLightShadowJob = PNOmniShadowJob.make(device: device) else { return nil }
        self.renderingSize = shadowTextureSize
        omniRenderingTexture = PNIDynamicTexture(device: device)
        omniShadowRPD = .omniLightShadow(device: device,
                                         texture: omniRenderingTexture.texture)
        self.device = device
        self.io = PNGPUIO(input: .empty,
                          output: PNGPUSupply(depth: [omniRenderingTexture]))
        self.omniShadowJob = omniLightShadowJob
    }
    func updateTextures(supply: PNFrameSupply) -> Bool {
        let omniCount = supply.scene.omniLights.count
        let omniDescriptor: MTLTextureDescriptor? = omniCount > 0 ? .omniShadowDS(size: renderingSize.omni, lightsCount: omniCount) : nil
        let omniUpdated = omniRenderingTexture.updateDescriptor(descriptor: omniDescriptor)
        return omniUpdated
    }
    func draw(commandBuffer: MTLCommandBuffer, supply: PNFrameSupply) {
        if updateTextures(supply: supply) {
            omniShadowRPD = .omniLightShadow(device: device,
                                             texture: omniRenderingTexture.texture)
        }
        if supply.scene.omniLights.isEmpty {
            return
        }
        if !supply.scene.omniLights.isEmpty,
           let encoder = commandBuffer.makeRenderCommandEncoder(descriptor: omniShadowRPD) {
            omniShadowJob.draw(encoder: encoder, supply: supply)
            encoder.endEncoding()
        }
    }
}
