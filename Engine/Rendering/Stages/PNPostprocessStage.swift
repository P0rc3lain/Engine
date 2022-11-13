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
                                                   inoutTexture: inputTexture),
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
        guard let encoderA = commandBuffer.makeComputeCommandEncoder() else {
            return
        }
        vignetteJob.compute(encoder: encoderA, supply: supply)
        encoderA.endEncoding()
        guard let encoderB = commandBuffer.makeRenderCommandEncoder(descriptor: postprocessRenderPassDescriptor) else {
            return
        }
        grainJob.draw(encoder: encoderB, supply: supply)
        encoderB.endEncoding()
        commandBuffer.popDebugGroup()
    }
}
