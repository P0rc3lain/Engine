//
//  Copyright © 2021 Mateusz Stompór. All rights reserved.
//

import Metal
import MetalBinding
import simd

struct PNOmniShadowJob: PNRenderJob {
    private let pipelineState: MTLRenderPipelineState
    private let animatedPipelineState: MTLRenderPipelineState
    private let depthStencilState: MTLDepthStencilState
    private var rotationsBuffer: PNAnyStaticBuffer<simd_float4x4>
    private let viewPort: MTLViewport
    init(pipelineState: MTLRenderPipelineState,
         animatedPipelineState: MTLRenderPipelineState,
         depthStencilState: MTLDepthStencilState,
         rotationsBuffer: PNAnyStaticBuffer<simd_float4x4>,
         viewPort: MTLViewport) {
        self.pipelineState = pipelineState
        self.animatedPipelineState = animatedPipelineState
        self.depthStencilState = depthStencilState
        self.viewPort = viewPort
        self.rotationsBuffer = rotationsBuffer
        var rotations = PNOmniShadowJob.rotationMatrices
        self.rotationsBuffer.upload(data: &rotations)
    }
    func draw(encoder: MTLRenderCommandEncoder, supply: PNFrameSupply) {
        guard !supply.scene.omniLights.isEmpty else {
            return
        }
        encoder.setViewport(viewPort)
        encoder.setDepthStencilState(depthStencilState)
        encoder.setRenderPipelineState(animatedPipelineState)
        encoder.setVertexBuffer(rotationsBuffer,
                                index: kAttributeOmniShadowVertexShaderBufferRotations)
        encoder.setVertexBuffer(supply.bufferStore.omniLights,
                                index: kAttributeOmniShadowVertexShaderBufferOmniLights)
        encoder.setVertexBuffer(supply.bufferStore.modelCoordinateSystems,
                                index: kAttributeOmniShadowVertexShaderBufferModelUniforms)
        for lightIndex in supply.scene.omniLights.count.naturalExclusive {
            for faceIndex in 6.naturalExclusive {
                var lIndex = lightIndex + faceIndex
                encoder.setVertexBytes(&lIndex,
                                       length: MemoryLayout<Int>.size,
                                       index: kAttributeOmniShadowVertexShaderBufferInstanceId)
                for animatedModel in supply.scene.animatedModels {
                    if !supply.mask.omniLights[lightIndex][faceIndex][animatedModel.idx] {
                        continue
                    }
                    encoder.setVertexBuffer(supply.bufferStore.matrixPalettes.buffer,
                                            offset: supply.scene.paletteOffset[animatedModel.skeleton],
                                            index: kAttributeOmniShadowVertexShaderBufferMatrixPalettes)
                    let mesh = supply.scene.meshes[animatedModel.mesh]
                    encoder.setFrontCulling(mesh.culling)
                    var mutableIndex = Int32(animatedModel.idx)
                    encoder.setVertexBytes(&mutableIndex,
                                           length: MemoryLayout<Int32>.size,
                                           index: kAttributeOmniShadowVertexShaderBufferObjectIndex)
                    encodeMeshDraw(commandEncoder: encoder, mesh: mesh)
                }
                encoder.setRenderPipelineState(pipelineState)
                for model in supply.scene.models {
                    if !supply.mask.omniLights[lightIndex][faceIndex][model.idx] {
                        continue
                    }
                    let mesh = supply.scene.meshes[model.mesh]
                    encoder.setFrontCulling(mesh.culling)
                    var mutableIndex = Int32(model.idx)
                    encoder.setVertexBytes(&mutableIndex,
                                           length: MemoryLayout<Int32>.size,
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
            encoder.drawIndexedPrimitives(submesh: pieceDescription.drawDescription)
        }
    }
    private static var rotationMatrices: [simd_float4x4] {
        [
            simd_quatf.environment.positiveX.rotationMatrix,
            simd_quatf.environment.negativeX.rotationMatrix,
            simd_quatf.environment.positiveY.rotationMatrix,
            simd_quatf.environment.negativeY.rotationMatrix,
            simd_quatf.environment.positiveZ.rotationMatrix,
            simd_quatf.environment.negativeZ.rotationMatrix
        ]
    }
    static func make(device: MTLDevice,
                     renderingSize: CGSize) -> PNOmniShadowJob? {
        guard let library = device.makePorcelainLibrary(),
              let pipelineState = device.makeRPSOmniShadow(library: library),
              let depthStencilState = device.makeDSSOmniLightShadow(),
              let animatedPipelineState = device.makeRPSOmniShadowAnimated(library: library),
              let rotationsBuffer = PNIStaticBuffer<simd_float4x4>(device: device, capacity: 6) else {
            return nil
        }
        return PNOmniShadowJob(pipelineState: pipelineState,
                               animatedPipelineState: animatedPipelineState,
                               depthStencilState: depthStencilState,
                               rotationsBuffer: PNAnyStaticBuffer(rotationsBuffer),
                               viewPort: .porcelain(size: renderingSize))
    }
}
