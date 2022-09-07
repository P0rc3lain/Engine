//
//  Copyright © 2021 Mateusz Stompór. All rights reserved.
//

import Foundation
import Metal

struct PNPostprocessStage: PNStage {
    var io: PNGPUIO
    private var vignetteJob: PNVignetteJob
    private var grainJob: PNGrainJob
    private var postprocessRenderPassDescriptor: MTLRenderPassDescriptor
    init?(device: MTLDevice, inputTexture: PNTextureProvider) {
        guard let texture = inputTexture.texture else {
            return nil
        }
        self.postprocessRenderPassDescriptor = .postprocess(device: device, texture: texture)
        guard let vignetteJob = PNVignetteJob.make(device: device,
                                                   inputTexture: inputTexture),
              let grainJob = PNGrainJob.make(device: device,
                                             inputTexture: inputTexture) else {
            return nil
        }
        self.vignetteJob = vignetteJob
        self.grainJob = grainJob
        self.io = PNGPUIO(input: PNGPUSupply(color: [inputTexture]),
                          output: PNGPUSupply(color: [inputTexture]))
    }
    func draw(commandBuffer: MTLCommandBuffer, supply: PNFrameSupply) {
        commandBuffer.pushDebugGroup("Post Processing Pass")
        guard let encoder = commandBuffer.makeRenderCommandEncoder(descriptor: postprocessRenderPassDescriptor) else {
            return
        }
        vignetteJob.draw(encoder: encoder, supply: supply)
        grainJob.draw(encoder: encoder, supply: supply)
        encoder.endEncoding()
        commandBuffer.popDebugGroup()
    }
}
