//
//  Copyright © 2021 Mateusz Stompór. All rights reserved.
//

import Metal
import MetalBinding
import simd

struct PNBloomMergeJob: PNComputeJob {
    private let pipelineState: MTLComputePipelineState
    private let sceneTexture: PNTextureProvider
    private let brightAreasTexture: PNTextureProvider
    private let dispatchSize: MTLSize
    private let threadGroupSize: MTLSize
    init?(pipelineState: MTLComputePipelineState,
          sceneTexture: PNTextureProvider,
          brightAreasTexture: PNTextureProvider) {
        self.pipelineState = pipelineState
        self.sceneTexture = sceneTexture
        self.brightAreasTexture = brightAreasTexture
        guard let inputTexture = sceneTexture.texture else {
            return nil
        }
        dispatchSize = MTLSize(width: inputTexture.width,
                               height: inputTexture.height,
                               depth: 1)
        threadGroupSize = MTLSize(width: 8, height: 8, depth: 1)
    }
    func compute(encoder: MTLComputeCommandEncoder, supply: PNFrameSupply) {
        encoder.setComputePipelineState(pipelineState)
        encoder.setTexture(sceneTexture.texture,
                           index: kAttributeBloomMergeComputeShaderTextureOriginal.int)
        var time = Float(Date().timeIntervalSince1970.truncatingRemainder(dividingBy: 20))
        encoder.setBytes(&time,
                         length: MemoryLayout<Float>.size,
                         index: kAttributeBloomMergeComputeShaderBufferTime.int)
        encoder.setTexture(brightAreasTexture.texture,
                           index: kAttributeBloomMergeComputeShaderTextureBrightAreas.int
        )
        encoder.dispatchThreads(dispatchSize, threadsPerThreadgroup: threadGroupSize)
    }
    static func make(device: MTLDevice,
                     sceneTexture: PNTextureProvider,
                     brightAreasTexture: PNTextureProvider) -> PNBloomMergeJob? {
        guard let library = device.makePorcelainLibrary(),
              let pipelineState = device.makeCPSBloomMerge(library: library) else {
            return nil
        }
        return PNBloomMergeJob(pipelineState: pipelineState,
                               sceneTexture: sceneTexture,
                               brightAreasTexture: brightAreasTexture)
    }
}
