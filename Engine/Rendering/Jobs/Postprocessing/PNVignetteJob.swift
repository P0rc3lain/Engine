//
//  Copyright © 2021 Mateusz Stompór. All rights reserved.
//

import Metal
import MetalBinding
import simd

struct PNVignetteJob: PNComputeJob {
    private let pipelineState: MTLComputePipelineState
    private let inoutTexture: PNTextureProvider
    private let dispatchSize: MTLSize
    private let threadGroupSize: MTLSize
    init?(pipelineState: MTLComputePipelineState,
          inoutTexture: PNTextureProvider) {
        self.inoutTexture = inoutTexture
        self.pipelineState = pipelineState
        guard let inoutTexture = inoutTexture.texture else {
            return nil
        }
        dispatchSize = MTLSize(width: inoutTexture.width,
                               height: inoutTexture.height,
                               depth: 1)
        threadGroupSize = MTLSize(width: 8, height: 8, depth: 1)
    }
    func compute(encoder: MTLComputeCommandEncoder, supply: PNFrameSupply) {
        encoder.setTexture(inoutTexture.texture,
                           index: kAttributeVignetteComputeShaderTexture.int)
        encoder.setComputePipelineState(pipelineState)
        encoder.dispatchThreads(dispatchSize, threadsPerThreadgroup: threadGroupSize)
    }
    static func make(device: MTLDevice,
                     inoutTexture: PNTextureProvider) -> PNVignetteJob? {
        guard let library = device.makePorcelainLibrary(),
              let pipelineState = device.makeCPSVignette(library: library) else {
            return nil
        }
        return PNVignetteJob(pipelineState: pipelineState,
                             inoutTexture: inoutTexture)
    }
}
