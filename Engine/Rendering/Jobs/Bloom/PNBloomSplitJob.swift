//
//  Copyright © 2021 Mateusz Stompór. All rights reserved.
//

import Metal
import MetalBinding
import MetalPerformanceShaders
import simd

struct PNBloomSplitJob: PNRenderJob {
    private let pipelineState: MTLRenderPipelineState
    private let viewPort: MTLViewport
    private let inputTexture: MTLTexture
    private let plane: PNMesh
    init?(pipelineState: MTLRenderPipelineState,
          inputTexture: MTLTexture,
          device: MTLDevice,
          drawableSize: CGSize) {
        guard let plane = PNMesh.screenSpacePlane(device: device) else {
            return nil
        }
        self.pipelineState = pipelineState
        self.inputTexture = inputTexture
        self.plane = plane
        self.viewPort = .porcelain(size: drawableSize)
    }
    func draw(encoder: MTLRenderCommandEncoder, supply: PNFrameSupply) {
        encoder.setViewport(viewPort)
        encoder.setRenderPipelineState(pipelineState)
        encoder.setVertexBuffer(plane.vertexBuffer.buffer,
                                index: kAttributeBloomSplitVertexShaderBufferStageIn)
        encoder.setFragmentTexture(inputTexture, index: kAttributeBloomSplitFragmentShaderTextureInput)
        encoder.drawIndexedPrimitives(type: .triangle,
                                      indexCount: plane.pieceDescriptions[0].drawDescription.indexCount,
                                      indexType: plane.pieceDescriptions[0].drawDescription.indexType,
                                      indexBuffer: plane.pieceDescriptions[0].drawDescription.indexBuffer.buffer,
                                      indexBufferOffset: plane.pieceDescriptions[0].drawDescription.indexBuffer.offset)
    }
    static func make(device: MTLDevice,
                     inputTexture: MTLTexture,
                     drawableSize: CGSize) -> PNBloomSplitJob? {
        guard let library = device.makePorcelainLibrary(),
              let pipelineState = device.makeRPSBloomSplit(library: library) else {
            return nil
        }
        return PNBloomSplitJob(pipelineState: pipelineState,
                               inputTexture: inputTexture,
                               device: device,
                               drawableSize: drawableSize)
    }
}
