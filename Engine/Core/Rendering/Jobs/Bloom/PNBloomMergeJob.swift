//
//  Copyright © 2021 Mateusz Stompór. All rights reserved.
//

import Metal
import PNShared
import simd

struct PNPostprocessMergeJob: PNComputeJob {
    private let pipelineState: MTLComputePipelineState
    private let sceneTexture: PNTextureProvider
    private let outputTexture: PNTextureProvider
    private let brightAreasTexture: PNTextureProvider
    private let velocitiesTexture: PNTextureProvider
    private let dispatchSize: MTLSize
    init?(pipelineState: MTLComputePipelineState,
          sceneTexture: PNTextureProvider,
          velocities: PNTextureProvider,
          output: PNTextureProvider,
          brightAreasTexture: PNTextureProvider) {
        self.pipelineState = pipelineState
        self.sceneTexture = sceneTexture
        self.brightAreasTexture = brightAreasTexture
        self.velocitiesTexture = velocities
        self.outputTexture = output
        guard let inputTexture = sceneTexture.texture else {
            return nil
        }
        dispatchSize = MTLSize(width: inputTexture.width, height: inputTexture.height)
    }
    func compute(encoder: MTLComputeCommandEncoder, supply: PNFrameSupply) {
        encoder.setComputePipelineState(pipelineState)
        encoder.setTexture(sceneTexture, index: kAttributePostprocessMergeComputeShaderTextureOriginal)
        encoder.setTexture(velocitiesTexture, index: kAttributePostprocessMergeComputeShaderTextureVelocities)
        encoder.setBytes(Float(Date().timeIntervalSince1970.truncatingRemainder(dividingBy: 20)),
                         index: kAttributePostprocessMergeComputeShaderBufferTime)
        encoder.setTexture(brightAreasTexture, index: kAttributePostprocessMergeComputeShaderTextureBrightAreas)
        encoder.setTexture(outputTexture, index: kAttributePostprocessMergeComputeShaderTextureOutput)
        encoder.dispatchThreads(dispatchSize,
                                threadsPerThreadgroup: pipelineState.suggestedThreadGroupSize)
    }
    static func make(device: MTLDevice,
                     sceneTexture: PNTextureProvider,
                     velocities: PNTextureProvider,
                     output: PNTextureProvider,
                     brightAreasTexture: PNTextureProvider) -> PNPostprocessMergeJob? {
        let library = device.makePorcelainLibrary()
        let pipelineState = device.makeCPSPostprocessMerge(library: library)
        return PNPostprocessMergeJob(pipelineState: pipelineState,
                                     sceneTexture: sceneTexture,
                                     velocities: velocities,
                                     output: output,
                                     brightAreasTexture: brightAreasTexture)
    }
}
