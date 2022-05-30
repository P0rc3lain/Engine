//
//  Copyright © 2021 Mateusz Stompór. All rights reserved.
//

import Metal
import MetalBinding
import simd

struct PNGrainJob: PNRenderJob {
    private let pipelineState: MTLRenderPipelineState
    private let inputTexture: MTLTexture
    private let viewPort: MTLViewport
    private let plane: PNMesh
    init(pipelineState: MTLRenderPipelineState,
         inputTexture: MTLTexture,
         plane: PNMesh,
         canvasSize: CGSize) {
        self.inputTexture = inputTexture
        self.pipelineState = pipelineState
        self.plane = plane
        self.viewPort = .porcelain(size: canvasSize)
    }
    func draw(encoder: MTLRenderCommandEncoder, supply: PNFrameSupply) {
        encoder.setFragmentTexture(inputTexture,
                                   index: kAttributeGrainFragmentShaderTexture)
        encoder.setViewport(viewPort)
        var time = Float(Date().timeIntervalSince1970.truncatingRemainder(dividingBy: 20))
        encoder.setVertexBytes(&time,
                               length: MemoryLayout<Float>.size,
                               index: kAttributeGrainVertexShaderBufferTime)
        encoder.setRenderPipelineState(pipelineState)
        encoder.setVertexBuffer(plane.vertexBuffer.buffer,
                                index: kAttributeGrainVertexShaderBufferStageIn)
        encoder.drawIndexedPrimitives(submesh: plane.pieceDescriptions[0].drawDescription)
    }
    static func make(device: MTLDevice,
                     inputTexture: MTLTexture,
                     canvasSize: CGSize) -> PNGrainJob? {
        guard let library = device.makePorcelainLibrary(),
              let pipelineState = device.makeRPSGrain(library: library),
              let plane = PNMesh.screenSpacePlane(device: device) else {
            return nil
        }
        return PNGrainJob(pipelineState: pipelineState,
                          inputTexture: inputTexture,
                          plane: plane,
                          canvasSize: canvasSize)
    }
}
