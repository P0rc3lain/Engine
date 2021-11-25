//
//  Copyright © 2021 Mateusz Stompór. All rights reserved.
//

import Metal
import MetalBinding
import MetalKit
import MetalPerformanceShaders
import simd

struct RenderingCoordinator {
    private let view: MTKView
    private let commandQueue: MTLCommandQueue
    private var bufferStore: BufferStore
    private var pipeline: PNPipeline
    private let imageConverter: MPSImageConversion
    init?(view metalView: MTKView, renderingSize: CGSize) {
        guard let device = metalView.device,
              let bufferStore = BufferStore(device: device),
              let commandQueue = device.makeCommandQueue(),
              let pipeline = PNPipeline(device: device, renderingSize: renderingSize) else {
            return nil
        }
        self.imageConverter = MPSImageConversion(device: device)
        self.view = metalView
        self.pipeline = pipeline
        self.bufferStore = bufferStore
        self.commandQueue = commandQueue
    }
    mutating func draw(sceneGraph: inout PNScene) {
        let transcriber = PNITranscriber(transformCalculator: PNITransformCalculator(interpolator: PNIInterpolator()))
        var scene = transcriber.transcribe(scene: sceneGraph)
        guard scene.activeCameraIdx != .nil,
              var commandBuffer = commandQueue.makeCommandBuffer(),
              let drawable = view.currentDrawable,
              let outputTexture = view.currentRenderPassDescriptor?.colorAttachments[0].texture else {
            return
        }
        bufferStore.matrixPalettes.upload(data: &scene.palettes)
        bufferStore.ambientLights.upload(data: &scene.ambientLights)
        bufferStore.omniLights.upload(data: &scene.omniLights)
        bufferStore.directionalLights.upload(data: &scene.directionalLights)
        bufferStore.spotLights.upload(data: &scene.spotLights)
        bufferStore.upload(camera: &scene.cameras[scene.entities[scene.activeCameraIdx].data.referenceIdx],
                           index: scene.activeCameraIdx)
        bufferStore.modelCoordinateSystems.upload(data: &scene.uniforms)
        pipeline.draw(commandBuffer: &commandBuffer,
                      scene: &scene,
                      bufferStore: &bufferStore)
        imageConverter.encode(commandBuffer: commandBuffer,
                              sourceTexture: pipeline.io.output.color[0],
                              destinationTexture: outputTexture)
        commandBuffer.present(drawable)
        commandBuffer.commit()
    }
}
