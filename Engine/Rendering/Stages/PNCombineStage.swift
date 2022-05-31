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
    private var directionalJob: PNRenderJob
    private var translucentJob: PNTranslucentJob
    private var renderPassDescriptor: MTLRenderPassDescriptor
    private var ssaoTexture: MTLTexture
    init?(device: MTLDevice,
          renderingSize: CGSize,
          gBufferOutput: PNGPUSupply,
          ssaoTexture: MTLTexture,
          spotLightShadows: MTLTexture,
          pointLightsShadows: MTLTexture,
          directionalLightsShadows: MTLTexture) {
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
              let translucentJob = PNTranslucentJob.make(device: device,
                                                         drawableSize: renderingSize),
              let fogJob = PNFogJob.make(device: device,
                                         drawableSize: renderingSize,
                                         prTexture: gBufferOutput.color[2]) else {
            return nil
        }
        renderPassDescriptor = .lightenScene(device: device,
                                             stencil: gBufferOutput.stencil[0],
                                             depth: gBufferOutput.depth[0],
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
        self.directionalJob = directionalJob
        self.io = PNGPUIO(input: PNGPUSupply(color: gBufferOutput.color + [ssaoTexture],
                                             stencil: gBufferOutput.stencil),
                          output: PNGPUSupply(color: [outputTexture]))
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
        fogJob.draw(encoder: encoder, supply: supply)
        encoder.endEncoding()
        commandBuffer.popDebugGroup()
    }
}
