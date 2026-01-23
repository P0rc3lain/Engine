//
//  Copyright © 2025 Mateusz Stompór. All rights reserved.
//

import Metal

struct PNBoundingBoxJob: PNRenderJob {
    private let pipelineState: MTLRenderPipelineState
    private let depthStencilState: MTLDepthStencilState
    init(pipelineState: MTLRenderPipelineState,
         depthStencilState: MTLDepthStencilState) {
        self.pipelineState = pipelineState
        self.depthStencilState = depthStencilState
    }
    func draw(encoder: MTLRenderCommandEncoder, supply: PNFrameSupply) {
        let dataStore = supply.bufferStore
        encoder.setCullMode(.none)
        encoder.setFrontFacing(.counterClockwise)
        encoder.setDepthStencilState(depthStencilState)
        encoder.setVertexBuffer(dataStore.boundingBoxes.buffer, index: 0)
        encoder.setStencilReferenceValue(1)
        encoder.setVertexBuffer(dataStore.cameras.buffer, index: 1)
        encoder.setVertexBuffer(dataStore.modelCoordinateSystems.buffer, index: 2)
        encoder.setRenderPipelineState(pipelineState)
        encoder.drawPrimitives(type: .line, vertexStart: 0, vertexCount: dataStore.boundingBoxes.count)
    }
    static func make(device: MTLDevice) -> PNBoundingBoxJob? {
        let library = device.makePorcelainLibrary()
        let pipelineState = device.makeRPSBoundingBox(library: library)
        let depthStencilState = device.makeDSSBoundingBox()
        return PNBoundingBoxJob(pipelineState: pipelineState,
                                depthStencilState: depthStencilState)
    }
}
