//
//  Copyright © 2021 Mateusz Stompór. All rights reserved.
//

import Metal
import MetalBinding
import simd

struct PNBloomMergeJob: PNRenderJob {
    private let pipelineState: MTLRenderPipelineState
    private let plane: PNMesh
    private let unmodifiedSceneTexture: PNTextureProvider
    private let brightAreasTexture: PNTextureProvider
    init?(pipelineState: MTLRenderPipelineState,
          device: MTLDevice,
          unmodifiedSceneTexture: PNTextureProvider,
          brightAreasTexture: PNTextureProvider) {
        guard let plane = PNMesh.plane(device: device) else {
            return nil
        }
        self.pipelineState = pipelineState
        self.plane = plane
        self.unmodifiedSceneTexture = unmodifiedSceneTexture
        self.brightAreasTexture = brightAreasTexture
    }
    func draw(encoder: MTLRenderCommandEncoder, supply: PNFrameSupply) {
        encoder.setRenderPipelineState(pipelineState)
        encoder.setVertexBuffer(plane.vertexBuffer.buffer,
                                index: kAttributeBloomSplitVertexShaderBufferStageIn)
        encoder.setFragmentTexture(unmodifiedSceneTexture,
                                   index: kAttributeBloomMergeFragmentShaderTextureOriginal)
        encoder.setFragmentTexture(brightAreasTexture,
                                   index: kAttributeBloomMergeFragmentShaderTextureBrightAreas)
        encoder.drawIndexedPrimitives(submesh: plane.pieceDescriptions[0].drawDescription)
    }
    static func make(device: MTLDevice,
                     unmodifiedSceneTexture: PNTextureProvider,
                     brightAreasTexture: PNTextureProvider) -> PNBloomMergeJob? {
        guard let library = device.makePorcelainLibrary(),
              let pipelineState = device.makeRPSBloomMerge(library: library) else {
            return nil
        }
        return PNBloomMergeJob(pipelineState: pipelineState,
                               device: device,
                               unmodifiedSceneTexture: unmodifiedSceneTexture,
                               brightAreasTexture: brightAreasTexture)
    }
}
