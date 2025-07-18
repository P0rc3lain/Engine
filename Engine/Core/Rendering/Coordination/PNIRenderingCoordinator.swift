//
//  Copyright © 2021 Mateusz Stompór. All rights reserved.
//

import Metal
import MetalKit
import MetalPerformanceShaders
import simd
import os.signpost

let logger = OSLog(subsystem: "com.yourcompany.yourapp", category: "performance")

struct PNIRenderingCoordinator: PNRenderingCoordinator {
    private let view: MTKView
    private let commandQueue: MTLCommandQueue
    private var pipeline: PNPipeline
    private let imageConverter: MPSImageConversion
    var frame: Int = 0
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
                
        let currentFrame = frame
        
        let idid = OSSignpostID(log: logger)
        
        os_signpost(.begin, log: logger, name: "Encoding frame", signpostID: idid, "Frame: %{public}d", currentFrame)
        pipeline.draw(commandBuffer: commandBuffer, supply: frameSupply)
        commandBuffer.pushDebugGroup("Copy Pass")
        imageConverter.encode(commandBuffer: commandBuffer,
                              sourceTexture: sourceTexture,
                              destinationTexture: outputTexture)
        commandBuffer.popDebugGroup()
        commandBuffer.present(drawable)
        
        let frameID = OSSignpostID(UInt64(frame))
        
        commandBuffer.addScheduledHandler { _ in
            os_signpost(.begin, log: logger, name: "Rendering Frame", signpostID: frameID, "Frame: %{public}d", currentFrame)
        }
        commandBuffer.addCompletedHandler { _ in
            os_signpost(.end, log: logger, name: "Rendering Frame", signpostID: frameID, "Frame: %{public}d", currentFrame)
        }
        os_signpost(.end, log: logger, name: "Encoding frame", signpostID: idid, "Frame: %{public}d", currentFrame)
        commandBuffer.commit()
        commandBuffer.waitUntilCompleted()
        
        frame += 1
    }
}
