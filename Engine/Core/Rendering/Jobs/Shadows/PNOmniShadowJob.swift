//
//  Copyright © 2021 Mateusz Stompór. All rights reserved.
//

import Metal
import PNShared
import simd

struct PNOmniShadowJob: PNRenderJob {
    private let pipelineState: MTLRenderPipelineState
    private let animatedPipelineState: MTLRenderPipelineState
    private let depthStencilState: MTLDepthStencilState
    private var rotationsBuffer: PNAnyStaticBuffer<simd_float4x4>
    init(pipelineState: MTLRenderPipelineState,
         animatedPipelineState: MTLRenderPipelineState,
         depthStencilState: MTLDepthStencilState,
         rotationsBuffer: PNAnyStaticBuffer<simd_float4x4>) {
        self.pipelineState = pipelineState
        self.animatedPipelineState = animatedPipelineState
        self.depthStencilState = depthStencilState
        self.rotationsBuffer = rotationsBuffer
        self.rotationsBuffer.upload(data: PNSurroundings.rotationMatrices)
    }
    func draw(encoder: MTLRenderCommandEncoder, supply: PNFrameSupply) {
        let shadowCasterIndices = supply.scene.omniLights.indices.filter {
            supply.scene.omniLights[$0].castsShadows == 1
        }
        guard !shadowCasterIndices.isEmpty else {
            return
        }
        encoder.setDepthStencilState(depthStencilState)
        encoder.setRenderPipelineState(animatedPipelineState)
        encoder.setVertexBuffer(rotationsBuffer,
                                index: kAttributeOmniShadowVertexShaderBufferRotations)
        encoder.setVertexBuffer(supply.bufferStore.omniLights,
                                index: kAttributeOmniShadowVertexShaderBufferOmniLights)
        encoder.setVertexBuffer(supply.bufferStore.modelCoordinateSystems,
                                index: kAttributeOmniShadowVertexShaderBufferModelUniforms)
        for lightIndex in shadowCasterIndices {
            for faceIndex in 6.exclusiveON {
                encoder.setVertexBytes(value: 6 * lightIndex + faceIndex,
                                       index: kAttributeOmniShadowVertexShaderBufferInstanceId)
                for animatedModel in supply.scene.animatedModels {
                    if !supply.mask.omniLights[lightIndex][animatedModel.idx] {
                        continue
                    }
                    encoder.setVertexBuffer(supply.bufferStore.matrixPalettes.buffer,
                                            offset: supply.scene.paletteOffset[animatedModel.skeleton],
                                            index: kAttributeOmniShadowVertexShaderBufferMatrixPalettes)
                    let mesh = supply.scene.meshes[animatedModel.mesh]
                    encoder.setFrontCulling(mesh.culling)
                    encoder.setVertexBytes(value: animatedModel.idx,
                                           index: kAttributeOmniShadowVertexShaderBufferObjectIndex)
                    encodeMeshDraw(commandEncoder: encoder, mesh: mesh)
                }
                encoder.setRenderPipelineState(pipelineState)
                for model in supply.scene.models {
                    if !supply.mask.omniLights[lightIndex][model.idx] {
                        continue
                    }
                    let mesh = supply.scene.meshes[model.mesh]
                    encoder.setFrontCulling(mesh.culling)
                    encoder.setVertexBytes(value: model.idx,
                                           index: kAttributeOmniShadowVertexShaderBufferObjectIndex)
                    encodeMeshDraw(commandEncoder: encoder, mesh: mesh)
                }
            }
        }
    }
    private func encodeMeshDraw(commandEncoder encoder: MTLRenderCommandEncoder, mesh: PNMesh) {
        encoder.setVertexBuffer(mesh.vertexBuffer.buffer,
                                offset: mesh.vertexBuffer.offset,
                                index: kAttributeOmniShadowVertexShaderBufferStageIn)
        for pieceDescription in mesh.pieceDescriptions {
            if let material = pieceDescription.material, material.isTranslucent {
                continue
            }
            encoder.drawIndexedPrimitives(submesh: pieceDescription.drawDescription)
        }
    }
    static func make(device: MTLDevice) -> PNOmniShadowJob? {
        let library = device.makePorcelainLibrary()
        let pipelineState = device.makeRPSOmniShadow(library: library)
        let animatedPipelineState = device.makeRPSOmniShadowAnimated(library: library)
        let depthStencilState = device.makeDSSOmniLightShadow()
        guard let rotationsBuffer = PNIStaticBuffer<simd_float4x4>(device: device, capacity: 6) else {
            return nil
        }
        return PNOmniShadowJob(pipelineState: pipelineState,
                               animatedPipelineState: animatedPipelineState,
                               depthStencilState: depthStencilState,
                               rotationsBuffer: PNAnyStaticBuffer(rotationsBuffer))
    }
}
