//
//  Copyright © 2022 Mateusz Stompór. All rights reserved.
//

import Metal
import PNShared
import simd

struct PNParticleJob: PNRenderJob {
    private let pipelineState: MTLRenderPipelineState
    private let depthStencilState: MTLDepthStencilState
    init(pipelineState: MTLRenderPipelineState,
         depthStencilState: MTLDepthStencilState) {
        self.pipelineState = pipelineState
        self.depthStencilState = depthStencilState
    }
    func draw(encoder: MTLRenderCommandEncoder, supply: PNFrameSupply) {
        let scene = supply.scene
        let dataStore = supply.bufferStore
        let mask = supply.mask.cameras[scene.entities[scene.activeCameraIdx].data.referenceIdx]
        encoder.setDepthStencilState(depthStencilState)
        encoder.setVertexBuffer(dataStore.cameras.buffer,
                                index: kAttributeParticleVertexShaderBufferCameraUniforms)
        encoder.setStencilReferenceValue(1)
        encoder.setRenderPipelineState(pipelineState)
        encoder.setVertexBuffer(dataStore.modelCoordinateSystems,
                                index: kAttributeParticleVertexShaderBufferModelUniforms)
        for index in scene.particles.count.exclusiveON {
            if !mask[index] {
                continue
            }
            let particleSystem = scene.particles[index]
            encoder.setFragmentTexture(particleSystem.atlas.texture,
                                       index: kAttributeParticleFragmentShaderAtlas)
            encoder.setFragmentBytes(value: particleSystem.atlas.useableTiles,
                                     index: kAttributeParticleFragmentShaderBufferUseableTiles)
            encoder.setFragmentBytes(value: particleSystem.atlas.grid,
                                     index: kAttributeParticleFragmentShaderBufferGrid)
            encoder.setVertexBytes(value: particleSystem.index,
                                   index: kAttributeParticleVertexShaderBufferSystemIndex)
            encoder.setVertexBuffer(particleSystem.particles.buffer,
                                    index: kAttributeParticleVertexShaderBufferStageIn)
            encoder.drawPrimitives(type: .point, vertexStart: 0, vertexCount: particleSystem.particles.count)
        }
    }
    static func make(device: MTLDevice) -> PNParticleJob? {
        let library = device.makePorcelainLibrary()
        let depthStencilState = device.makeDSSParticle()
        let pipelineState = device.makeRPSParticle(library: library)
        return PNParticleJob(pipelineState: pipelineState,
                             depthStencilState: depthStencilState)
    }
}
