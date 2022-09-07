//
//  Copyright © 2021 Mateusz Stompór. All rights reserved.
//

import Metal
import MetalPerformanceShaders

struct PNBloomStage: PNStage {
    var io: PNGPUIO
    private var bloomSplitJob: PNBloomSplitJob
    private var bloomMergeJob: PNBloomMergeJob
    private let gaussianBlurJob: MPSImageGaussianBlur
    private let splitBlurredTexture: MTLTexture
    private var bloomSplitRenderPassDescriptor: MTLRenderPassDescriptor
    private let bloomMergeRenderPassDescriptor: MTLRenderPassDescriptor
    init?(input: PNTextureProvider, device: MTLDevice, renderingSize: CGSize) {
        bloomSplitRenderPassDescriptor = .bloomSplit(device: device, size: renderingSize)
        bloomMergeRenderPassDescriptor = .bloomMerge(device: device, size: renderingSize)
        guard let bloomSplitJob = PNBloomSplitJob.make(device: device,
                                                       inputTexture: input),
              let stageOutputTexture = bloomMergeRenderPassDescriptor.colorAttachments[0].texture,
              let splitBlurredTexture = device.makeTexture(descriptor: .bloomSplitC(size: renderingSize)),
              let bloomMergeJob = PNBloomMergeJob.make(device: device,
                                                       unmodifiedSceneTexture: input,
                                                       brightAreasTexture: PNStaticTexture(splitBlurredTexture)) else {
            return nil
        }
        self.gaussianBlurJob = MPSImageGaussianBlur(device: device, sigma: 2)
        self.bloomSplitJob = bloomSplitJob
        self.bloomMergeJob = bloomMergeJob
        self.splitBlurredTexture = splitBlurredTexture
        self.io = PNGPUIO(input: PNGPUSupply(color: [input]),
                          output: PNGPUSupply(color: [PNStaticTexture(stageOutputTexture)]))
    }
    func draw(commandBuffer: MTLCommandBuffer, supply: PNFrameSupply) {
        commandBuffer.pushDebugGroup("Bloom Pass")
        guard let bloomSplitEncoder = commandBuffer.makeRenderCommandEncoder(descriptor: bloomSplitRenderPassDescriptor),
              let gaussianBlurSource = bloomSplitRenderPassDescriptor.colorAttachments[0].texture else {
            return
        }
        bloomSplitJob.draw(encoder: bloomSplitEncoder, supply: supply)
        bloomSplitEncoder.endEncoding()
        gaussianBlurJob.encode(commandBuffer: commandBuffer,
                               sourceTexture: gaussianBlurSource,
                               destinationTexture: splitBlurredTexture)
        commandBuffer.popDebugGroup()
        commandBuffer.pushDebugGroup("Bloom Merge Pass")
        guard let bloomMergeEncoder = commandBuffer.makeRenderCommandEncoder(descriptor: bloomMergeRenderPassDescriptor) else {
            return
        }
        bloomMergeJob.draw(encoder: bloomMergeEncoder, supply: supply)
        bloomMergeEncoder.endEncoding()
        commandBuffer.popDebugGroup()
    }
}
