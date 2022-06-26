//
//  Copyright © 2021 Mateusz Stompór. All rights reserved.
//

import Metal
import MetalBinding
import MetalKit
import MetalPerformanceShaders
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
              let outputTexture = view.currentRenderPassDescriptor?.colorAttachments[0].texture else {
            return
        }
        pipeline.draw(commandBuffer: commandBuffer, supply: frameSupply)
        commandBuffer.pushDebugGroup("Copy Pass")
        imageConverter.encode(commandBuffer: commandBuffer,
                              sourceTexture: pipeline.io.output.color[0].texture!,
                              destinationTexture: outputTexture)
        commandBuffer.popDebugGroup()
        commandBuffer.present(drawable)
        commandBuffer.commit()
        commandBuffer.waitUntilCompleted()
    }
}
