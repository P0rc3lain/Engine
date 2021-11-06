//
//  Copyright © 2021 Mateusz Stompór. All rights reserved.
//

import Metal
import MetalBinding
import MetalKit
import MetalPerformanceShaders

public struct RenderingCoordinator {
    private let view: MTKView
    private let commandQueue: MTLCommandQueue
    private var offscreenRenderPassDescriptor: MTLRenderPassDescriptor
    private var postProcessor: Postprocessor
    private var environmentRenderer: EnvironmentRenderer
    private var lightRenderer: LightPassRenderer
    private var bufferStore: BufferStore
    private var ssaoStage: SSAOStage
    private var bloomStage: BloomStage
    private var gBufferStage: GBufferStage
    private let canvasSize: CGSize
    let renderingSize: CGSize
    init?(view metalView: MTKView, canvasSize: CGSize, renderingSize: CGSize) {
        guard let device = metalView.device,
              let bufferStore = BufferStore(device: device),
              let commandQueue = device.makeCommandQueue(),
              let gBufferStage = GBufferStage(device: device, renderingSize: renderingSize) else {
            return nil
        }
        offscreenRenderPassDescriptor = .lightenScene(device: device,
                                                      depthStencil: gBufferStage.io.output.stencil!,
                                                      size: renderingSize)
        guard let bloomStage = BloomStage(input: offscreenRenderPassDescriptor.colorAttachments[0].texture!,
                                          device: device,
                                          renderingSize: renderingSize),
              let postProcessor = Postprocessor.make(device: device,
                                                     inputTexture: bloomStage.io.output.color[0],
                                                     outputFormat: metalView.colorPixelFormat,
                                                     canvasSize: canvasSize),
              let environmentRenderer = EnvironmentRenderer.make(device: device, drawableSize: metalView.drawableSize),
              let lightRenderer = LightPassRenderer.make(device: device,
                                                         inputTextures: gBufferStage.io.output.color,
                                                         drawableSize: renderingSize),
              
              let ssaoStage = SSAOStage(device: device,
                                        renderingSize: renderingSize,
                                        prTexture: gBufferStage.io.output.color[0],
                                        nmTexture: gBufferStage.io.output.color[1]) else {
            return nil
        }
        self.gBufferStage = gBufferStage
        self.view = metalView
        self.canvasSize = canvasSize
        self.renderingSize = renderingSize
        self.bufferStore = bufferStore
        self.bloomStage = bloomStage
        self.commandQueue = commandQueue
        self.postProcessor = postProcessor
        self.environmentRenderer = environmentRenderer
        self.lightRenderer = lightRenderer
        self.ssaoStage = ssaoStage
    }
    public mutating func draw(scene: inout GPUSceneDescription) {
        guard scene.activeCameraIdx != .nil,
              var commandBuffer = commandQueue.makeCommandBuffer(),
              let renderPassDescriptor = view.currentRenderPassDescriptor,
              let drawable = view.currentDrawable else {
            return
        }
        updatePalettes(scene: &scene)
        bufferStore.omniLights.upload(data: &scene.lights)
        bufferStore.upload(camera: &scene.cameras[scene.entities[scene.activeCameraIdx].data.referenceIdx], index: scene.activeCameraIdx)
        bufferStore.upload(models: &scene.entities)
        gBufferStage.draw(commandBuffer: &commandBuffer, scene: &scene, bufferStore: &bufferStore)
        ssaoStage.draw(commandBuffer: &commandBuffer, bufferStore: &bufferStore)
        commandBuffer.pushDebugGroup("Light Pass")
        guard var lightEncoder = commandBuffer.makeRenderCommandEncoder(descriptor: offscreenRenderPassDescriptor) else {
            return
        }
        lightRenderer.draw(encoder: &lightEncoder,
                           bufferStore: &bufferStore,
                           lightsCount: scene.lights.count,
                           ssao: ssaoStage.io.output.color[0])
        commandBuffer.popDebugGroup()
        commandBuffer.pushDebugGroup("Environment Map")
        environmentRenderer.draw(encoder: &lightEncoder, scene: &scene)
        lightEncoder.endEncoding()
        commandBuffer.popDebugGroup()
        bloomStage.draw(commandBuffer: &commandBuffer)
        guard let texturePass = commandBuffer.makeRenderCommandEncoder(descriptor: renderPassDescriptor) else {
            return
        }
        commandBuffer.pushDebugGroup("Post Processing Pass")
        postProcessor.draw(encoder: texturePass)
        texturePass.endEncoding()
        commandBuffer.popDebugGroup()
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
