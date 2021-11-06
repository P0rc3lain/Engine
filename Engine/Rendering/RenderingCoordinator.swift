//
//  Copyright © 2021 Mateusz Stompór. All rights reserved.
//

import Metal
import MetalBinding
import MetalKit
import MetalPerformanceShaders

public struct RenderingCoordinator {
    private let view: MTKView
    private let canvasSize: CGSize
    private let commandQueue: MTLCommandQueue
    private var bufferStore: BufferStore
    private var combineStage: CombineStage
    private var ssaoStage: SSAOStage
    private var bloomStage: BloomStage
    private var gBufferStage: GBufferStage
    private var postprocessStage: PostprocessStage
    private let imageConverter: MPSImageConversion
    let renderingSize: CGSize
    init?(view metalView: MTKView, canvasSize: CGSize, renderingSize: CGSize) {
        guard let device = metalView.device,
              let bufferStore = BufferStore(device: device),
              let commandQueue = device.makeCommandQueue(),
              let gBufferStage = GBufferStage(device: device, renderingSize: renderingSize),
              let ssaoStage = SSAOStage(device: device,
                                        renderingSize: renderingSize,
                                        prTexture: gBufferStage.io.output.color[2],
                                        nmTexture: gBufferStage.io.output.color[1]),
              let combineStage = CombineStage(device: device,
                                              renderingSize: renderingSize,
                                              gBufferOutput: gBufferStage.io.output,
                                              ssaoTexture: ssaoStage.io.output.color[0]),
              let bloomStage = BloomStage(input: combineStage.io.output.color[0],
                                          device: device,
                                          renderingSize: renderingSize),
              let postprocessStage = PostprocessStage(device: device,
                                                      inputTexture: bloomStage.io.output.color[0],
                                                      renderingSize: canvasSize) else {
            return nil
        }
        self.gBufferStage = gBufferStage
        self.imageConverter = MPSImageConversion(device: device)
        self.view = metalView
        self.canvasSize = canvasSize
        self.combineStage = combineStage
        self.renderingSize = renderingSize
        self.bufferStore = bufferStore
        self.bloomStage = bloomStage
        self.commandQueue = commandQueue
        self.ssaoStage = ssaoStage
        self.postprocessStage = postprocessStage
    }
    public mutating func draw(scene: inout GPUSceneDescription) {
        guard scene.activeCameraIdx != .nil,
              var commandBuffer = commandQueue.makeCommandBuffer(),
              let drawable = view.currentDrawable,
              let outputTexture = view.currentRenderPassDescriptor?.colorAttachments[0].texture else {
            return
        }
        updatePalettes(scene: &scene)
        bufferStore.ambientLights.upload(data: &scene.ambientLights)
        bufferStore.omniLights.upload(data: &scene.omniLights)
        bufferStore.upload(camera: &scene.cameras[scene.entities[scene.activeCameraIdx].data.referenceIdx], index: scene.activeCameraIdx)
        bufferStore.upload(models: &scene.entities)
        gBufferStage.draw(commandBuffer: &commandBuffer, scene: &scene, bufferStore: &bufferStore)
        ssaoStage.draw(commandBuffer: &commandBuffer, bufferStore: &bufferStore)
        combineStage.draw(commandBuffer: &commandBuffer, scene: &scene, bufferStore: &bufferStore)
        bloomStage.draw(commandBuffer: &commandBuffer)
        postprocessStage.draw(commandBuffer: &commandBuffer)
        imageConverter.encode(commandBuffer: commandBuffer,
                              sourceTexture: postprocessStage.io.output.color[0],
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
        bufferStore.upload(palettes: &continousPalette)
    }
    func generatePalette(objectIdx: Int, scene: inout GPUSceneDescription) -> [simd_float4x4] {
        if scene.skeletonReferences[objectIdx] == .nil {
            return []
        } else {
            let skeletonIdx = scene.skeletonReferences[objectIdx]
            let skeleton = scene.skeletons[skeletonIdx]
            var palette = [matrix_float4x4]()
            palette.reserveCapacity(skeleton.bindTransforms.count)
            let animationReference = scene.animationReferences[skeletonIdx]
            let date = Date().timeIntervalSince1970
            let animation = scene.skeletalAnimations[animationReference.lowerBound]
            let transformations = animation.localTransformation(at: date)
            let pose = skeleton.computeWorldBindTransforms(localBindTransform: transformations)
            for index in skeleton.bindTransforms.indices {
                palette.append(pose[index] * skeleton.inverseBindTransforms[index])
            }
            return palette
        }
    }
}
