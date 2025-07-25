//
//  Copyright © 2021 Mateusz Stompór. All rights reserved.
//

import Metal
import MetalPerformanceShaders

struct PNPostprocessStage: PNStage {
    var io: PNGPUIO
    private var bloomSplitJob: PNBloomSplitJob
    private var postprocessMergeJob: PNPostprocessMergeJob
    private let gaussianBlurJob: MPSImageGaussianBlur
    private let splitBlurredTexture: MTLTexture
    private let bloomSplitTexture: MTLTexture
    private let postprocessOutputTexture: MTLTexture
    init?(input: PNTextureProvider,
          velocities: PNTextureProvider,
          bloomBlurSigma: Float,
          device: MTLDevice,
          renderingSize: CGSize) {
        guard let bloomSplitTexture = device.makeTextureBloomSplitC(size: renderingSize) else {
            return nil
        }
        guard let postprocessOutputTexture = device.makeTexturePostprocessOutput(size: renderingSize) else {
            return nil
        }
        self.bloomSplitTexture = bloomSplitTexture
        self.postprocessOutputTexture = postprocessOutputTexture
        guard let bloomSplitJob = PNBloomSplitJob.make(device: device,
                                                       inputTexture: input,
                                                       outputTexture: PNStaticTexture(bloomSplitTexture)),
              let splitBlurredTexture = device.makeTexture(descriptor: .bloomSplitC(size: renderingSize)),
              let postprocessMergeJob = PNPostprocessMergeJob.make(device: device,
                                                                   sceneTexture: input,
                                                                   velocities: velocities,
                                                                   output: PNStaticTexture(postprocessOutputTexture),
                                                                   brightAreasTexture: PNStaticTexture(splitBlurredTexture)) else {
            return nil
        }
        self.gaussianBlurJob = MPSImageGaussianBlur(device: device,
                                                    sigma: bloomBlurSigma)
        self.bloomSplitJob = bloomSplitJob
        self.postprocessMergeJob = postprocessMergeJob
        self.splitBlurredTexture = splitBlurredTexture
        self.io = PNGPUIO(input: PNGPUSupply(color: [input]),
                          output: PNGPUSupply(color: [postprocessOutputTexture]))
    }
    func draw(commandQueue: MTLCommandQueue, supply: PNFrameSupply) {
        guard let commandBuffer = commandQueue.makeCommandBuffer(),
              let bloomSplitEncoder = commandBuffer.makeComputeCommandEncoder() else {
            return
        }
        commandBuffer.label = "Bloom"
        commandBuffer.pushDebugGroup("Bloom Pass")
        bloomSplitJob.compute(encoder: bloomSplitEncoder, supply: supply)
        bloomSplitEncoder.endEncoding()
        gaussianBlurJob.encode(commandBuffer: commandBuffer,
                               sourceTexture: bloomSplitTexture,
                               destinationTexture: splitBlurredTexture)
        commandBuffer.popDebugGroup()
        commandBuffer.commit()
        guard let commandBuffer = commandQueue.makeCommandBuffer(),
              let postprocessMergeEncoder = commandBuffer.makeComputeCommandEncoder() else {
            return
        }
        commandBuffer.label = "Final Merge"
        commandBuffer.pushDebugGroup("Postprocess Merge Pass")
        postprocessMergeJob.compute(encoder: postprocessMergeEncoder, supply: supply)
        postprocessMergeEncoder.endEncoding()
        commandBuffer.popDebugGroup()
        commandBuffer.commit()
    }
}
