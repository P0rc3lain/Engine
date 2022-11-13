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
    private let bloomSplitTexture: MTLTexture
    init?(input: PNTextureProvider, device: MTLDevice, renderingSize: CGSize) {
        guard let bloomSplitTexture = device.makeTextureBloomSplitC(size: renderingSize) else {
            return nil
        }
        self.bloomSplitTexture = bloomSplitTexture
        guard let bloomSplitJob = PNBloomSplitJob.make(device: device,
                                                       inputTexture: input,
                                                       outputTexture: PNStaticTexture(bloomSplitTexture)),
              let splitBlurredTexture = device.makeTexture(descriptor: .bloomSplitC(size: renderingSize)),
              let bloomMergeJob = PNBloomMergeJob.make(device: device,
                                                       sceneTexture: input,
                                                       brightAreasTexture: PNStaticTexture(splitBlurredTexture)) else {
            return nil
        }
        self.gaussianBlurJob = MPSImageGaussianBlur(device: device, sigma: 2)
        self.bloomSplitJob = bloomSplitJob
        self.bloomMergeJob = bloomMergeJob
        self.splitBlurredTexture = splitBlurredTexture
        self.io = PNGPUIO(input: PNGPUSupply(color: [input]),
                          output: PNGPUSupply(color: [input]))
    }
    func draw(commandBuffer: MTLCommandBuffer, supply: PNFrameSupply) {
        commandBuffer.pushDebugGroup("Bloom Pass")
        guard let bloomSplitEncoder = commandBuffer.makeComputeCommandEncoder() else {
            return
        }
        bloomSplitJob.compute(encoder: bloomSplitEncoder, supply: supply)
        bloomSplitEncoder.endEncoding()
        gaussianBlurJob.encode(commandBuffer: commandBuffer,
                               sourceTexture: bloomSplitTexture,
                               destinationTexture: splitBlurredTexture)
        commandBuffer.popDebugGroup()
        commandBuffer.pushDebugGroup("Bloom Merge Pass")
        guard let bloomMergeEncoder = commandBuffer.makeComputeCommandEncoder() else {
            return
        }
        bloomMergeJob.compute(encoder: bloomMergeEncoder, supply: supply)
        bloomMergeEncoder.endEncoding()
        commandBuffer.popDebugGroup()
    }
}
