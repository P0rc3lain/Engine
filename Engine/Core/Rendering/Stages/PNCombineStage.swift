//
//  Copyright © 2021 Mateusz Stompór. All rights reserved.
//

import CoreGraphics
import Foundation
import Metal

struct PNBBJob: PNRenderJob {
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
        encoder.setVertexBuffer(dataStore.cameras.buffer,
                                index: 1)
        encoder.setVertexBuffer(dataStore.modelCoordinateSystems.buffer,
                                index: 2)
        encoder.setRenderPipelineState(pipelineState)
        encoder.drawPrimitives(type: .line, vertexStart: 0, vertexCount: dataStore.boundingBoxes.count)
    }
    static func make(device: MTLDevice) -> PNBBJob? {
        let library = device.makePorcelainLibrary()
        let pipelineState = device.makeRPSBoundingBox(library: library)
        let depthStencilState = device.makeDSSBoundingBox()
        return PNBBJob(pipelineState: pipelineState,
                       depthStencilState: depthStencilState)
    }
}


struct PNCombineStage: PNStage {
    var io: PNGPUIO
    private var environmentJob: PNRenderJob
    private var fogJob: PNRenderJob
    private var omniJob: PNRenderJob
    private var ambientJob: PNRenderJob
    private var spotJob: PNRenderJob
    private var particleJob: PNRenderJob
    private var directionalJob: PNRenderJob
    private var translucentJob: PNTranslucentJob
    private var renderPassDescriptor: MTLRenderPassDescriptor
    private var ssaoTexture: PNTextureProvider
    private var boundingBoxJob: PNRenderJob
    init?(device: MTLDevice,
          renderingSize: CGSize,
          gBufferOutput: PNGPUSupply,
          ssaoTexture: PNTextureProvider,
          spotLightShadows: PNTextureProvider,
          pointLightsShadows: PNTextureProvider,
          directionalLightsShadows: PNTextureProvider) {
        guard let environmentJob = PNEnvironmentJob.make(device: device),
              let omniJob = PNOmniJob.make(device: device,
                                           inputTextures: gBufferOutput.color,
                                           shadowMaps: pointLightsShadows),
              let ambientJob = PNAmbientJob.make(device: device,
                                                 inputTextures: gBufferOutput.color,
                                                 ssaoTexture: ssaoTexture),
              let directionalJob = PNDirectionalJob.make(device: device,
                                                         inputTextures: gBufferOutput.color,
                                                         shadowMap: directionalLightsShadows),
              let spotJob = PNSpotJob.make(device: device,
                                           inputTextures: gBufferOutput.color,
                                           shadowMap: spotLightShadows),
              let particleJob = PNParticleJob.make(device: device),
              let translucentJob = PNTranslucentJob.make(device: device),
              let fogJob = PNFogJob.make(device: device,
                                         prTexture: gBufferOutput.color[2]),
              let stencil = gBufferOutput.stencil[0].texture,
              let depth = gBufferOutput.depth[0].texture else {
            return nil
        }
        renderPassDescriptor = .lightenScene(device: device,
                                             stencil: stencil,
                                             depth: depth,
                                             size: renderingSize)
        guard let outputTexture = renderPassDescriptor.colorAttachments[0].texture else {
            return nil
        }
        self.ambientJob = ambientJob
        self.ssaoTexture = ssaoTexture
        self.environmentJob = environmentJob
        self.omniJob = omniJob
        self.spotJob = spotJob
        self.fogJob = fogJob
        self.translucentJob = translucentJob
        self.boundingBoxJob = PNBBJob.make(device: device)!
        self.particleJob = particleJob
        self.directionalJob = directionalJob
        self.io = PNGPUIO(input: PNGPUSupply(color: gBufferOutput.color + [ssaoTexture],
                                             stencil: gBufferOutput.stencil),
                          output: PNGPUSupply(color: [PNStaticTexture(outputTexture)]))
    }
    func draw(commandBuffer: MTLCommandBuffer, supply: PNFrameSupply) {
        guard let encoder = commandBuffer.makeRenderCommandEncoder(descriptor: renderPassDescriptor) else {
            return
        }
        omniJob.draw(encoder: encoder, supply: supply)
        ambientJob.draw(encoder: encoder, supply: supply)
        spotJob.draw(encoder: encoder, supply: supply)
        directionalJob.draw(encoder: encoder, supply: supply)
        environmentJob.draw(encoder: encoder, supply: supply)
        translucentJob.draw(encoder: encoder, supply: supply)
        particleJob.draw(encoder: encoder, supply: supply)
        fogJob.draw(encoder: encoder, supply: supply)
        boundingBoxJob.draw(encoder: encoder, supply: supply)
        encoder.endEncoding()
    }
}
