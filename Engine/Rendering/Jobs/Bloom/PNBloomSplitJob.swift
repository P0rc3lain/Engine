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
    private let inputTexture: PNTextureProvider
    private let plane: PNMesh
    init?(pipelineState: MTLRenderPipelineState,
          inputTexture: PNTextureProvider,
          device: MTLDevice,
          drawableSize: CGSize) {
        guard let plane = PNMesh.plane(device: device) else {
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
        encoder.drawIndexedPrimitives(submesh: plane.pieceDescriptions[0].drawDescription)
    }
    static func make(device: MTLDevice,
                     inputTexture: PNTextureProvider,
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
