//
//  Copyright © 2021 Mateusz Stompór. All rights reserved.
//

import Metal
import MetalKit
import MetalPerformanceShaders
import os.signpost
import simd

struct PNIRenderingCoordinator: PNRenderingCoordinator {
    private let view: MTKView
    private let commandQueue: MTLCommandQueue
    private var pipeline: PNPipeline
    private let imageConverter: MPSImageConversion
    init?(view metalView: MTKView, renderingSize: CGSize) {
        guard let device = metalView.device,
              let commandQueue = device.makeCommandQueue(),
              let pipeline = PNPipeline(device: device, renderingSize: renderingSize) else {
            return nil
        }
        self.imageConverter = MPSImageConversion(device: device)
        self.view = metalView
        self.pipeline = pipeline
        self.commandQueue = commandQueue
    }
    mutating func draw(frameSupply: PNFrameSupply) {
        guard frameSupply.scene.activeCameraIdx != .nil,
              let commandBuffer = commandQueue.makeCommandBuffer(),
              let drawable = view.currentDrawable,
              let outputTexture = view.currentRenderPassDescriptor?.colorAttachments[0].texture,
              let sourceTexture = pipeline.io.output.color[0].texture else {
            return
        }
        commandBuffer.label = "Frame generation"
        let encodingInterval = psignposter.beginInterval("Frame encoding")
        pipeline.draw(commandBuffer: commandBuffer, supply: frameSupply)
        commandBuffer.pushDebugGroup("Copy Pass")
        imageConverter.encode(commandBuffer: commandBuffer,
                              sourceTexture: sourceTexture,
                              destinationTexture: outputTexture)
        commandBuffer.popDebugGroup()
        commandBuffer.present(drawable)
        var renderingInterval: OSSignpostIntervalState!
        commandBuffer.addScheduledHandler { _ in
            renderingInterval = psignposter.beginInterval("Rendering")
        }
        commandBuffer.addCompletedHandler { _ in
            psignposter.endInterval("Rendering", renderingInterval)
        }
        commandBuffer.commit()
        psignposter.endInterval("Frame encoding", encodingInterval)
        commandBuffer.waitUntilCompleted()
    }
}
