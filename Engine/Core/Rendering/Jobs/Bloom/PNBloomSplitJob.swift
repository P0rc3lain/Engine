//
//  Copyright © 2021 Mateusz Stompór. All rights reserved.
//

import Metal
import MetalPerformanceShaders
import PNAttribute
import simd

struct PNBloomSplitJob: PNComputeJob {
    private let pipelineState: MTLComputePipelineState
    private let inputTexture: PNTextureProvider
    private let outputTexture: PNTextureProvider
    private let dispatchSize: MTLSize
    init?(pipelineState: MTLComputePipelineState,
          inputTexture: PNTextureProvider,
          outputTexture: PNTextureProvider) {
        self.pipelineState = pipelineState
        self.inputTexture = inputTexture
        self.outputTexture = outputTexture
        guard let inputTexture = inputTexture.texture else {
            return nil
        }
        dispatchSize = MTLSize(width: inputTexture.width,
                               height: inputTexture.height)
    }
    func compute(encoder: MTLComputeCommandEncoder, supply: PNFrameSupply) {
        encoder.setComputePipelineState(pipelineState)
        encoder.setTexture(inputTexture, index: kAttributeBloomSplitComputeShaderTextureInput)
        encoder.setTexture(outputTexture, index: kAttributeBloomSplitComputeShaderTextureOutput)
        encoder.dispatchThreads(dispatchSize,
                                threadsPerThreadgroup: pipelineState.suggestedThreadGroupSize)
    }
    static func make(device: MTLDevice,
                     inputTexture: PNTextureProvider,
                     outputTexture: PNTextureProvider) -> PNBloomSplitJob? {
        let library = device.makePorcelainLibrary()
        let pipelineState = device.makeCPSBloomSplit(library: library)
        return PNBloomSplitJob(pipelineState: pipelineState,
                               inputTexture: inputTexture,
                               outputTexture: outputTexture)
    }
}
