//
//  Copyright © 2021 Mateusz Stompór. All rights reserved.
//

import Metal

class PNDirectionalShadowStage: PNStage {
    var io: PNGPUIO
    private let device: MTLDevice
    private var directionalShadowRPD: MTLRenderPassDescriptor
    private var directionalRenderingTexture: PNDynamicTexture
    private let renderingSize: PNDefaults.PNShadowSize
    private var directionalShadowJob: PNDirectionalShadowJob
    init?(device: MTLDevice,
          shadowTextureSize: PNDefaults.PNShadowSize) {
        self.renderingSize = shadowTextureSize
        directionalRenderingTexture = PNIDynamicTexture(device: device)
        directionalShadowRPD = .directionalLightShadow(device: device,
                                                       texture: directionalRenderingTexture.texture)
        self.device = device
        guard let directionalLightShadowJob = PNDirectionalShadowJob.make(device: device) else {
            return nil
        }
        self.io = PNGPUIO(input: .empty,
                          output: PNGPUSupply(depth: [directionalRenderingTexture]))
        self.directionalShadowJob = directionalLightShadowJob
    }
    func updateTextures(supply: PNFrameSupply) -> Bool {
        let directionalCount = supply.scene.directionalLights.count
        let directionalDescriptor: MTLTextureDescriptor? = directionalCount > 0 ? .directionalShadowDS(size: renderingSize.directional,
                                                                                                       lightsCount: directionalCount) : nil
        let directionalUpdated = directionalRenderingTexture.updateDescriptor(descriptor: directionalDescriptor)
        return directionalUpdated
    }
    func draw(commandBuffer: MTLCommandBuffer, supply: PNFrameSupply) {
        if updateTextures(supply: supply) {
            directionalShadowRPD = .directionalLightShadow(device: device,
                                                           texture: directionalRenderingTexture.texture)
        }
        if supply.scene.directionalLights.isEmpty {
            return
        }
        if !supply.scene.directionalLights.isEmpty,
           let encoder = commandBuffer.makeRenderCommandEncoder(descriptor: directionalShadowRPD) {
            directionalShadowJob.draw(encoder: encoder, supply: supply)
            encoder.endEncoding()
        }
    }
}
