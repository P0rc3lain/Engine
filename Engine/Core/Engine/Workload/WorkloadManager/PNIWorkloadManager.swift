//
//  Copyright © 2021 Mateusz Stompór. All rights reserved.
//

/// A single-threaded rendering process coordinator.
public class PNIWorkloadManager: PNWorkloadManager {
    private var bufferStore: PNBufferStore
    private var renderingCoordinator: PNRenderingCoordinator
    private let transcriber: PNTranscriber
    private let renderMaskGenerator: PNRenderMaskGenerator
    private var previousFrameScene: PNSceneDescription?
    public init(bufferStore: PNBufferStore,
                renderingCoordinator: PNRenderingCoordinator,
                renderMaskGenerator: PNRenderMaskGenerator,
                transcriber: PNTranscriber) {
        self.bufferStore = bufferStore
        self.renderingCoordinator = renderingCoordinator
        self.transcriber = transcriber
        self.renderMaskGenerator = renderMaskGenerator
    }
    public func draw(sceneGraph: PNScene, taskQueue: PNRepeatableTaskQueue) {
        taskQueue.execute()
        let scene = transcriber.transcribe(scene: sceneGraph)
        bufferStore.matrixPalettes.upload(data: scene.palettes)
        bufferStore.ambientLights.upload(data: scene.ambientLights)
        bufferStore.omniLights.upload(data: scene.omniLights)
        bufferStore.directionalLights.upload(data: scene.directionalLights)
        bufferStore.spotLights.upload(data: scene.spotLights)
        bufferStore.cameras.upload(data: scene.cameraUniforms)
        bufferStore.modelCoordinateSystems.upload(data: scene.uniforms)
        let previous = previousFrameScene ?? scene
        bufferStore.previousMatrixPalettes.upload(data: previous.palettes)
        bufferStore.previousModelCoordinateSystems.upload(data: previous.uniforms)
        let supply = PNFrameSupply(scene: scene,
                                   bufferStore: bufferStore,
                                   mask: renderMaskGenerator.generate(scene: scene))
        previousFrameScene = scene
        renderingCoordinator.draw(frameSupply: supply)
    }
}
