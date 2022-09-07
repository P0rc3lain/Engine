//
//  Copyright © 2021 Mateusz Stompór. All rights reserved.
//

import Metal
import MetalBinding
import simd

struct PNVignetteJob: PNRenderJob {
    private let pipelineState: MTLRenderPipelineState
    private let inputTexture: PNTextureProvider
    private let plane: PNMesh
    init(pipelineState: MTLRenderPipelineState,
         inputTexture: PNTextureProvider,
         plane: PNMesh) {
        self.inputTexture = inputTexture
        self.pipelineState = pipelineState
        self.plane = plane
    }
    func draw(encoder: MTLRenderCommandEncoder, supply: PNFrameSupply) {
        encoder.setFragmentTexture(inputTexture,
                                   index: kAttributeVignetteFragmentShaderTexture)
        encoder.setRenderPipelineState(pipelineState)
        encoder.setVertexBuffer(plane.vertexBuffer.buffer,
                                index: kAttributeVignetteVertexShaderBufferStageIn)
        encoder.drawIndexedPrimitives(submesh: plane.pieceDescriptions[0].drawDescription)
    }
    static func make(device: MTLDevice,
                     inputTexture: PNTextureProvider) -> PNVignetteJob? {
        guard let library = device.makePorcelainLibrary(),
              let pipelineState = device.makeRPSVignette(library: library),
              let plane = PNMesh.plane(device: device) else {
            return nil
        }
        return PNVignetteJob(pipelineState: pipelineState,
                             inputTexture: inputTexture,
                             plane: plane)
    }
}
