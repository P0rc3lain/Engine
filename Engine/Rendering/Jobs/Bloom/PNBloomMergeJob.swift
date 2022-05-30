//
//  Copyright © 2021 Mateusz Stompór. All rights reserved.
//

import Metal
import MetalBinding
import simd

struct PNBloomMergeJob: PNRenderJob {
    private let pipelineState: MTLRenderPipelineState
    private let viewPort: MTLViewport
    private let plane: PNMesh
    private let unmodifiedSceneTexture: MTLTexture
    private let brightAreasTexture: MTLTexture
    init?(pipelineState: MTLRenderPipelineState,
          device: MTLDevice,
          unmodifiedSceneTexture: MTLTexture,
          brightAreasTexture: MTLTexture,
          drawableSize: CGSize) {
        guard let plane = PNMesh.plane(device: device) else {
            return nil
        }
        self.pipelineState = pipelineState
        self.plane = plane
        self.viewPort = .porcelain(size: drawableSize)
        self.unmodifiedSceneTexture = unmodifiedSceneTexture
        self.brightAreasTexture = brightAreasTexture
    }
    func draw(encoder: MTLRenderCommandEncoder, supply: PNFrameSupply) {
        encoder.setViewport(viewPort)
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
                     drawableSize: CGSize,
                     unmodifiedSceneTexture: MTLTexture,
                     brightAreasTexture: MTLTexture) -> PNBloomMergeJob? {
        guard let library = device.makePorcelainLibrary(),
              let pipelineState = device.makeRPSBloomMerge(library: library) else {
            return nil
        }
        return PNBloomMergeJob(pipelineState: pipelineState,
                               device: device,
                               unmodifiedSceneTexture: unmodifiedSceneTexture,
                               brightAreasTexture: brightAreasTexture,
                               drawableSize: drawableSize)
    }
}
