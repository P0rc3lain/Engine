//
//  Copyright © 2021 Mateusz Stompór. All rights reserved.
//

import Metal
import MetalBinding
import MetalPerformanceShaders
import simd

struct BloomSplitRenderer {
    private let pipelineState: MTLRenderPipelineState
    private let viewPort: MTLViewport
    private let inputTexture: MTLTexture
    private let plane: GPUGeometry
    private let gaussianBlur: MPSImageGaussianBlur
    let outputTexture: MTLTexture
    init?(pipelineState: MTLRenderPipelineState,
          inputTexture: MTLTexture,
          device: MTLDevice,
          drawableSize: CGSize) {
        guard let plane = GPUGeometry.screenSpacePlane(device: device),
              let outputTexture = device.makeTexture(descriptor: .bloomSplitColor(size: drawableSize)) else {
            return nil
        }
        self.pipelineState = pipelineState
        self.inputTexture = inputTexture
        self.plane = plane
        self.viewPort = .porcelain(size: drawableSize)
        self.gaussianBlur = MPSImageGaussianBlur(device: device, sigma: 15)
        self.outputTexture = outputTexture
    }
    mutating func draw(encoder: inout MTLRenderCommandEncoder, commandBuffer: inout MTLCommandBuffer, renderPass: inout MTLRenderPassDescriptor) {
        guard let gaussianBlurSource = renderPass.colorAttachments[0].texture else {
            fatalError("Required textures not bound")
        }
        encoder.setViewport(viewPort)
        encoder.setRenderPipelineState(pipelineState)
        encoder.setVertexBuffer(plane.vertexBuffer.buffer,
                                index: kAttributeBloomSplitVertexShaderBufferStageIn)
        encoder.setFragmentTexture(inputTexture, index: kAttributeBloomSplitFragmentShaderTextureInput)
        encoder.drawIndexedPrimitives(type: .triangle,
                                      indexCount: plane.pieceDescriptions[0].drawDescription.indexCount,
                                      indexType: plane.pieceDescriptions[0].drawDescription.indexType,
                                      indexBuffer: plane.pieceDescriptions[0].drawDescription.indexBuffer.buffer,
                                      indexBufferOffset: plane.pieceDescriptions[0].drawDescription.indexBuffer.offset)
        encoder.endEncoding()
        gaussianBlur.encode(commandBuffer: commandBuffer,
                            sourceTexture: gaussianBlurSource,
                            destinationTexture: outputTexture)
    }
}
