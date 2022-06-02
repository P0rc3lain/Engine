//
//  Copyright © 2022 Mateusz Stompór. All rights reserved.
//

import MetalBinding
import MetalKit
import simd

struct PNParticleJob: PNRenderJob {
    private let pipelineState: MTLRenderPipelineState
    private let depthStencilState: MTLDepthStencilState
    private let viewPort: MTLViewport
    init(pipelineState: MTLRenderPipelineState,
         depthStencilState: MTLDepthStencilState,
         drawableSize: CGSize) {
        self.pipelineState = pipelineState
        self.depthStencilState = depthStencilState
        self.viewPort = .porcelain(size: drawableSize)
    }
    func draw(encoder: MTLRenderCommandEncoder, supply: PNFrameSupply) {
        let scene = supply.scene
        let dataStore = supply.bufferStore
        let mask = supply.mask.cameras[scene.entities[scene.activeCameraIdx].data.referenceIdx]
        encoder.setViewport(viewPort)
        encoder.setDepthStencilState(depthStencilState)
        encoder.setVertexBuffer(dataStore.cameras.buffer,
                                index: kAttributeParticleVertexShaderBufferCameraUniforms)
        encoder.setStencilReferenceValue(1)
        encoder.setRenderPipelineState(pipelineState)
        encoder.setVertexBuffer(dataStore.modelCoordinateSystems,
                                index: kAttributeParticleVertexShaderBufferModelUniforms)
        for index in scene.particles.count.naturalExclusive {
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
            encoder.setVertexBytes(value: Int32(particleSystem.index),
                                   index: kAttributeParticleVertexShaderBufferSystemIndex)
            encoder.setVertexBuffer(particleSystem.particles.buffer,
                                    index: kAttributeParticleVertexShaderBufferStageIn)
            encoder.drawPrimitives(type: .point, vertexStart: 0, vertexCount: particleSystem.particles.count)
        }
    }
    static func make(device: MTLDevice, drawableSize: CGSize) -> PNParticleJob? {
        guard let library = device.makePorcelainLibrary(),
              let pipelineState = device.makeRPSParticle(library: library),
              let depthStencilState = device.makeDSSParticle() else {
            return nil
        }
        return PNParticleJob(pipelineState: pipelineState,
                             depthStencilState: depthStencilState,
                             drawableSize: drawableSize)
    }
}
