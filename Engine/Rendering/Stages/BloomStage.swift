//
//  Copyright © 2021 Mateusz Stompór. All rights reserved.
//

import Metal
import MetalPerformanceShaders

struct BloomStage: Stage {
    var io: GPUIO
    private var bloomSplitRenderer: BloomSplitRenderer
    private var bloomMergeRenderer: BloomMergeRenderer
    private var bloomSplitRenderPassDescriptor: MTLRenderPassDescriptor
    private let bloomMergeRenderPassDescriptor: MTLRenderPassDescriptor
    init?(input: MTLTexture, device: MTLDevice, renderingSize: CGSize) {
        bloomSplitRenderPassDescriptor = .bloomSplit(device: device, size: renderingSize)
        bloomMergeRenderPassDescriptor = .bloomMerge(device: device, size: renderingSize)
        guard let bloomSplitRenderer = BloomSplitRenderer.make(device: device,
                                                               inputTexture: input,
                                                               drawableSize: renderingSize),
              let bloomMergeRenderer = BloomMergeRenderer.make(device: device, drawableSize: renderingSize)  else {
            return nil
        }
        self.bloomSplitRenderer = bloomSplitRenderer
        self.bloomMergeRenderer = bloomMergeRenderer
        self.io = GPUIO(input: GPUSupply(color: [input]),
                        output: GPUSupply(color: [bloomMergeRenderPassDescriptor.colorAttachments[0].texture!]))
    }
    mutating func draw(commandBuffer: inout MTLCommandBuffer) {
        commandBuffer.pushDebugGroup("Bloom Pass")
        guard var bloomSplitEncoder = commandBuffer.makeRenderCommandEncoder(descriptor: bloomSplitRenderPassDescriptor) else {
            return
        }
        bloomSplitRenderer.draw(encoder: &bloomSplitEncoder,
                                commandBuffer: &commandBuffer,
                                renderPass: &bloomSplitRenderPassDescriptor)
        commandBuffer.popDebugGroup()
        commandBuffer.pushDebugGroup("Bloom Merge Pass")
        guard var bloomMergeEncoder = commandBuffer.makeRenderCommandEncoder(descriptor: bloomMergeRenderPassDescriptor) else {
            return
        }
        bloomMergeRenderer.draw(encoder: &bloomMergeEncoder,
                                unmodifiedSceneTexture: io.input.color[0],
                                brightAreasTexture: bloomSplitRenderer.outputTexture)
        bloomMergeEncoder.endEncoding()
        commandBuffer.popDebugGroup()
    }
}
