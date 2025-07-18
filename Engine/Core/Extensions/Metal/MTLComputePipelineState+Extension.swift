import Metal

extension MTLComputePipelineState {
    var suggestedThreadGroupSize: MTLSize {
        let height = maxTotalThreadsPerThreadgroup / threadExecutionWidth
        return MTLSize(width: threadExecutionWidth, height: height)
    }
}
