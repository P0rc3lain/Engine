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
    private var pipeline: Pipeline
    private let imageConverter: MPSImageConversion
    init?(view metalView: MTKView, renderingSize: CGSize) {
        guard let device = metalView.device,
              let bufferStore = BufferStore(device: device),
              let commandQueue = device.makeCommandQueue(),
              let pipeline = Pipeline(device: device, renderingSize: renderingSize) else {
            return nil
        }
        self.imageConverter = MPSImageConversion(device: device)
        self.view = metalView
        self.pipeline = pipeline
        self.bufferStore = bufferStore
        self.commandQueue = commandQueue
    }
    mutating func draw(scene: inout GPUSceneDescription) {
        guard scene.activeCameraIdx != .nil,
              var commandBuffer = commandQueue.makeCommandBuffer(),
              let drawable = view.currentDrawable,
              let outputTexture = view.currentRenderPassDescriptor?.colorAttachments[0].texture else {
            return
        }
        var arrangement = ArrangementController.arrangement(scene: &scene)
        updatePalettes(scene: &scene)
        bufferStore.ambientLights.upload(data: &scene.ambientLights)
        bufferStore.omniLights.upload(data: &scene.omniLights)
        bufferStore.directionalLights.upload(data: &scene.directionalLights)
        bufferStore.spotLights.upload(data: &scene.spotLights)
        bufferStore.upload(camera: &scene.cameras[scene.entities[scene.activeCameraIdx].data.referenceIdx],
                           index: scene.activeCameraIdx)
        bufferStore.modelCoordinateSystems.upload(data: &arrangement.positions)
        pipeline.draw(commandBuffer: &commandBuffer,
                      scene: &scene,
                      bufferStore: &bufferStore,
                      arrangement: &arrangement)
        imageConverter.encode(commandBuffer: commandBuffer,
                              sourceTexture: pipeline.io.output.color[0],
                              destinationTexture: outputTexture)
        commandBuffer.present(drawable)
        commandBuffer.commit()
    }
    mutating func updatePalettes(scene: inout GPUSceneDescription) {
        var continousPalette = [simd_float4x4]()
        scene.paletteReferences = []
        for index in scene.entities.indices {
            let palette = generatePalette(objectIdx: index, scene: &scene)
            scene.paletteReferences.append(continousPalette.count ..< continousPalette.count + palette.count)
            continousPalette += palette
        }
        bufferStore.matrixPalettes.upload(data: &continousPalette)
    }
    func generatePalette(objectIdx: Int, scene: inout GPUSceneDescription) -> [simd_float4x4] {
        if scene.skeletonReferences[objectIdx] == .nil {
            return []
        } else {
            let skeletonIdx = scene.skeletonReferences[objectIdx]
            let skeleton = scene.skeletons[skeletonIdx]
            let animationReference = scene.animationReferences[skeletonIdx]
            let date = Date().timeIntervalSince1970
            let animation = scene.skeletalAnimations[animationReference.lowerBound]
            let transformations = animation.localTransformation(at: date, interpolator: PNIInterpolator())
            return skeleton.calculatePose(animationPose: transformations)
        }
    }
}
