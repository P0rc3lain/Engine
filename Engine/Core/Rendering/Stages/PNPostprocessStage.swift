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
          bloomRenderingScale: Float,
          device: MTLDevice,
          renderingSize: CGSize) {
        let bloomSplitTextureSize = CGSize(width: renderingSize.width * CGFloat(bloomRenderingScale),
                                           height: renderingSize.height * CGFloat(bloomRenderingScale))

        guard let bloomSplitTexture = device.makeTextureBloomSplitC(size: bloomSplitTextureSize),
              let postprocessOutputTexture = device.makeTexturePostprocessOutput(size: renderingSize) else {
            return nil
        }
        self.bloomSplitTexture = bloomSplitTexture
        self.postprocessOutputTexture = postprocessOutputTexture
        guard let bloomSplitJob = PNBloomSplitJob.make(device: device,
                                                       inputTexture: input,
                                                       outputTexture: PNStaticTexture(bloomSplitTexture)),
              let splitBlurredTexture = device.makeTexture(descriptor: .bloomSplitC(size: bloomSplitTextureSize)),
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
    func draw(commandBuffer: MTLCommandBuffer, supply: PNFrameSupply) {
        guard let bloomSplitEncoder = commandBuffer.makeComputeCommandEncoder() else {
            fatalError("Failed to create an encoder for bloom split")
        }
        bloomSplitJob.compute(encoder: bloomSplitEncoder, supply: supply)
        bloomSplitEncoder.endEncoding()
        gaussianBlurJob.encode(commandBuffer: commandBuffer,
                               sourceTexture: bloomSplitTexture,
                               destinationTexture: splitBlurredTexture)
        guard let postprocessMergeEncoder = commandBuffer.makeComputeCommandEncoder() else {
            fatalError("Failed to create an encoder for postprocess merge")
        }
        postprocessMergeJob.compute(encoder: postprocessMergeEncoder, supply: supply)
        postprocessMergeEncoder.endEncoding()
    }
}
