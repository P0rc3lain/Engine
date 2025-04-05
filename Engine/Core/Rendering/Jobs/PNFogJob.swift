//
//  Copyright © 2021 Mateusz Stompór. All rights reserved.
//

import Metal
import PNShared
import simd

struct PNFogJob: PNRenderJob {
    private let pipelineState: MTLRenderPipelineState
    private let depthStentilState: MTLDepthStencilState
    private let prTexture: PNTextureProvider
    private let cube: PNMesh
    init(pipelineState: MTLRenderPipelineState,
         depthStentilState: MTLDepthStencilState,
         prTexture: PNTextureProvider,
         cube: PNMesh) {
        self.pipelineState = pipelineState
        self.depthStentilState = depthStentilState
        self.cube = cube
        self.prTexture = prTexture
    }
    func draw(encoder: MTLRenderCommandEncoder, supply: PNFrameSupply) {
        guard let skyMap = supply.scene.skyMap else {
            return
        }
        encoder.setStencilReferenceValue(0x1)
        encoder.setRenderPipelineState(pipelineState)
        encoder.setDepthStencilState(depthStentilState)
        encoder.setVertexBuffer(cube.vertexBuffer.buffer,
                                index: kAttributeFogVertexShaderBufferStageIn)
        encoder.setVertexBuffer(supply.bufferStore.modelCoordinateSystems,
                                index: kAttributeFogVertexShaderBufferModelUniforms)
        encoder.setVertexBuffer(supply.bufferStore.cameras,
                                offset: supply.scene.entities[supply.scene.activeCameraIdx].data.referenceIdx * MemoryLayout<CameraUniforms>.stride,
                                index: kAttributeFogVertexShaderBufferCameraUniforms)
        encoder.setFragmentTexture(skyMap,
                                   index: kAttributeFogFragmentShaderTextureCubeMap)
        encoder.setFragmentTexture(prTexture,
                                   index: kAttributeFogFragmentShaderTexturePR)
        encoder.drawIndexedPrimitives(submesh: cube.pieceDescriptions[0].drawDescription)
    }
    static func make(device: MTLDevice,
                     prTexture: PNTextureProvider) -> PNFogJob? {
        let library = device.makePorcelainLibrary()
        let fogPipelineState = device.makeRPSFog(library: library)
        let depthStencilState = device.makeDSSFog()
        guard let cube = PNMesh.cube(device: device) else {
            return nil
        }
        return PNFogJob(pipelineState: fogPipelineState,
                        depthStentilState: depthStencilState,
                        prTexture: prTexture,
                        cube: cube)
    }
}
