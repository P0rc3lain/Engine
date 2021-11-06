//
//  Copyright © 2021 Mateusz Stompór. All rights reserved.
//

import Metal
import MetalBinding
import simd

fileprivate struct Uniforms {
    let projectionMatrix: matrix_float4x4
    let orientation: matrix_float4x4
}

struct EnvironmentRenderer {
    private let pipelineState: MTLRenderPipelineState
    private let depthStentilState: MTLDepthStencilState
    private let viewPort: MTLViewport
    private let cube: GPUGeometry
    init(pipelineState: MTLRenderPipelineState,
         depthStentilState: MTLDepthStencilState,
         drawableSize: CGSize,
         cube: GPUGeometry) {
        self.pipelineState = pipelineState
        self.depthStentilState = depthStentilState
        self.cube = cube
        self.viewPort = .porcelain(size: drawableSize)
    }
    func draw(encoder: inout MTLRenderCommandEncoder, scene: inout GPUSceneDescription) {
        if scene.sky == .nil {
            return
        }
        encoder.setViewport(viewPort)
        encoder.setRenderPipelineState(pipelineState)
        encoder.setVertexBuffer(cube.vertexBuffer.buffer,
                                index: kAttributeEnvironmentVertexShaderBufferStageIn)
        encoder.setDepthStencilState(depthStentilState)
        encoder.setStencilReferenceValue(0)
        encoder.setFragmentTexture(scene.skyMaps[scene.sky],
                                   index: kAttributeEnvironmentFragmentShaderTextureCubeMap)
        let cameraIndex = scene.entities[scene.activeCameraIdx].data.referenceIdx
        let orientation = simd_matrix4x4(scene.entities[scene.activeCameraIdx].data.transform.rotation.interpolated(at: Date().timeIntervalSince1970))
        let uniforms = Uniforms(projectionMatrix: scene.cameras[cameraIndex].projectionMatrix,
                                orientation: orientation)
        withUnsafePointer(to: uniforms) { ptr in
            encoder.setVertexBytes(ptr,
                                   length: MemoryLayout<Uniforms>.size,
                                   index: kAttributeEnvironmentVertexShaderBufferUniforms)
        }
        encoder.drawIndexedPrimitives(type: .triangle,
                                      indexCount: cube.pieceDescriptions[0].drawDescription.indexBuffer.length / MemoryLayout<UInt16>.size,
                                      indexType: .uint16,
                                      indexBuffer: cube.pieceDescriptions[0].drawDescription.indexBuffer.buffer,
                                      indexBufferOffset: 0)
    }
}