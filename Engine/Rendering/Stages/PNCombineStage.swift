//
//  Copyright © 2021 Mateusz Stompór. All rights reserved.
//

import Foundation
import Metal

struct PNCombineStage: PNStage {
    var io: PNGPUIO
    private var environmentJob: PNRenderJob
    private var fogJob: PNRenderJob
    private var omniJob: PNRenderJob
    private var ambientJob: PNRenderJob
    private var spotJob: PNRenderJob
    private var particleJob: PNRenderJob
    private var directionalJob: PNRenderJob
    private var translucentJob: PNTranslucentJob
    private var renderPassDescriptor: MTLRenderPassDescriptor
    private var ssaoTexture: PNTextureProvider
    init?(device: MTLDevice,
          renderingSize: CGSize,
          gBufferOutput: PNGPUSupply,
          ssaoTexture: PNTextureProvider,
          spotLightShadows: PNTextureProvider,
          pointLightsShadows: PNTextureProvider,
          directionalLightsShadows: PNTextureProvider) {
        guard let environmentJob = PNEnvironmentJob.make(device: device,
                                                         drawableSize: renderingSize),
              let omniJob = PNOmniJob.make(device: device,
                                           inputTextures: gBufferOutput.color,
                                           shadowMaps: pointLightsShadows,
                                           drawableSize: renderingSize),
              let ambientJob = PNAmbientJob.make(device: device,
                                                 inputTextures: gBufferOutput.color,
                                                 ssaoTexture: ssaoTexture,
                                                 drawableSize: renderingSize),
              let directionalJob = PNDirectionalJob.make(device: device,
                                                         inputTextures: gBufferOutput.color,
                                                         shadowMap: directionalLightsShadows,
                                                         drawableSize: renderingSize),
              let spotJob = PNSpotJob.make(device: device,
                                           inputTextures: gBufferOutput.color,
                                           shadowMap: spotLightShadows,
                                           drawableSize: renderingSize),
              let particleJob = PNParticleJob.make(device: device,
                                                   drawableSize: renderingSize),
              let translucentJob = PNTranslucentJob.make(device: device,
                                                         drawableSize: renderingSize),
              let fogJob = PNFogJob.make(device: device,
                                         drawableSize: renderingSize,
                                         prTexture: gBufferOutput.color[2]),
              let stencil = gBufferOutput.stencil[0].texture,
              let depth = gBufferOutput.depth[0].texture else {
            return nil
        }
        renderPassDescriptor = .lightenScene(device: device,
                                             stencil: stencil,
                                             depth: depth,
                                             size: renderingSize)
        guard let outputTexture = renderPassDescriptor.colorAttachments[0].texture else {
            return nil
        }
        self.ambientJob = ambientJob
        self.ssaoTexture = ssaoTexture
        self.environmentJob = environmentJob
        self.omniJob = omniJob
        self.spotJob = spotJob
        self.fogJob = fogJob
        self.translucentJob = translucentJob
        self.particleJob = particleJob
        self.directionalJob = directionalJob
        self.io = PNGPUIO(input: PNGPUSupply(color: gBufferOutput.color + [ssaoTexture],
                                             stencil: gBufferOutput.stencil),
                          output: PNGPUSupply(color: [PNStaticTexture(outputTexture)]))
    }
    func draw(commandBuffer: MTLCommandBuffer, supply: PNFrameSupply) {
        commandBuffer.pushDebugGroup("Light Pass")
        guard let encoder = commandBuffer.makeRenderCommandEncoder(descriptor: renderPassDescriptor) else {
            return
        }
        omniJob.draw(encoder: encoder, supply: supply)
        ambientJob.draw(encoder: encoder, supply: supply)
        spotJob.draw(encoder: encoder, supply: supply)
        directionalJob.draw(encoder: encoder, supply: supply)
        environmentJob.draw(encoder: encoder, supply: supply)
        translucentJob.draw(encoder: encoder, supply: supply)
        particleJob.draw(encoder: encoder, supply: supply)
        fogJob.draw(encoder: encoder, supply: supply)
        encoder.endEncoding()
        commandBuffer.popDebugGroup()
    }
}
