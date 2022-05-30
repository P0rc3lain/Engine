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
        guard let plane = PNMesh.screenSpacePlane(device: device) else {
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
        encoder.setFragmentTexture(unmodifiedSceneTexture, index: kAttributeBloomMergeFragmentShaderTextureOriginal)
        encoder.setFragmentTexture(brightAreasTexture, index: kAttributeBloomMergeFragmentShaderTextureBrightAreas)
        encoder.drawIndexedPrimitives(type: .triangle,
                                      indexCount: plane.pieceDescriptions[0].drawDescription.indexCount,
                                      indexType: plane.pieceDescriptions[0].drawDescription.indexType,
                                      indexBuffer: plane.pieceDescriptions[0].drawDescription.indexBuffer.buffer,
                                      indexBufferOffset: plane.pieceDescriptions[0].drawDescription.indexBuffer.offset)
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
