//
//  Copyright © 2021 Mateusz Stompór. All rights reserved.
//

import Metal
import MetalBinding
import simd

struct PNEnvironmentJob: PNRenderJob {
    private let pipelineState: MTLRenderPipelineState
    private let depthStentilState: MTLDepthStencilState
    private let cube: PNMesh
    init(pipelineState: MTLRenderPipelineState,
         depthStentilState: MTLDepthStencilState,
         cube: PNMesh) {
        self.pipelineState = pipelineState
        self.depthStentilState = depthStentilState
        self.cube = cube
    }
    func draw(encoder: MTLRenderCommandEncoder, supply: PNFrameSupply) {
        guard let skyMap = supply.scene.skyMap else {
            return
        }
        encoder.setStencilReferenceValue(0)
        encoder.setRenderPipelineState(pipelineState)
        encoder.setDepthStencilState(depthStentilState)
        encoder.setVertexBuffer(cube.vertexBuffer.buffer,
                                index: kAttributeEnvironmentVertexShaderBufferStageIn)
        encoder.setVertexBuffer(supply.bufferStore.modelCoordinateSystems,
                                index: kAttributeEnvironmentVertexShaderBufferModelUniforms)
        encoder.setVertexBuffer(supply.bufferStore.cameras,
                                offset: supply.scene.entities[supply.scene.activeCameraIdx].data.referenceIdx * MemoryLayout<CameraUniforms>.stride,
                                index: kAttributeEnvironmentVertexShaderBufferCameraUniforms)
        encoder.setFragmentTexture(skyMap,
                                   index: kAttributeEnvironmentFragmentShaderTextureCubeMap)
        encoder.drawIndexedPrimitives(submesh: cube.pieceDescriptions[0].drawDescription)
    }
    static func make(device: MTLDevice) -> PNEnvironmentJob? {
        guard let library = device.makePorcelainLibrary(),
              let environmentPipelineState = device.makeRPSEnvironment(library: library),
              let depthStencilState = device.makeDSSEnvironment(),
              let cube = PNMesh.cube(device: device) else {
            return nil
        }
        return PNEnvironmentJob(pipelineState: environmentPipelineState,
                                depthStentilState: depthStencilState,
                                cube: cube)
    }
}
