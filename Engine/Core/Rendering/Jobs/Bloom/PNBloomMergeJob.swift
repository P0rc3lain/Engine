//
//  Copyright © 2021 Mateusz Stompór. All rights reserved.
//

import Metal
import PNShared
import simd

struct PNBloomMergeJob: PNComputeJob {
    private let pipelineState: MTLComputePipelineState
    private let sceneTexture: PNTextureProvider
    private let outputTexture: PNTextureProvider
    private let brightAreasTexture: PNTextureProvider
    private let velocitiesTexture: PNTextureProvider
    private let dispatchSize: MTLSize
    private let threadGroupSize: MTLSize
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
        threadGroupSize = MTLSize(width: 8, height: 8)
    }
    func compute(encoder: MTLComputeCommandEncoder, supply: PNFrameSupply) {
        encoder.setComputePipelineState(pipelineState)
        encoder.setTexture(sceneTexture, index: kAttributeBloomMergeComputeShaderTextureOriginal)
        encoder.setTexture(velocitiesTexture, index: kAttributeBloomMergeComputeShaderTextureVelocities)
        encoder.setBytes(Float(Date().timeIntervalSince1970.truncatingRemainder(dividingBy: 20)),
                         index: kAttributeBloomMergeComputeShaderBufferTime)
        encoder.setTexture(brightAreasTexture, index: kAttributeBloomMergeComputeShaderTextureBrightAreas)
        encoder.setTexture(outputTexture, index: kAttributeBloomMergeComputeShaderTextureOutput)
        encoder.dispatchThreads(dispatchSize, threadsPerThreadgroup: threadGroupSize)
    }
    static func make(device: MTLDevice,
                     sceneTexture: PNTextureProvider,
                     velocities: PNTextureProvider,
                     output: PNTextureProvider,
                     brightAreasTexture: PNTextureProvider) -> PNBloomMergeJob? {
        let library = device.makePorcelainLibrary()
        let pipelineState = device.makeCPSBloomMerge(library: library)
        return PNBloomMergeJob(pipelineState: pipelineState,
                               sceneTexture: sceneTexture,
                               velocities: velocities,
                               output: output,
                               brightAreasTexture: brightAreasTexture)
    }
}
