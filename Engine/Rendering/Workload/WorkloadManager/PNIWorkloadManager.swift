//
//  Copyright © 2021 Mateusz Stompór. All rights reserved.
//

public class PNIWorkloadManager: PNWorkloadManager {
    private var bufferStore: PNBufferStore
    private var renderingCoordinator: PNRenderingCoordinator
    private let transcriber: PNTranscriber
    private let renderMaskGenerator: PNRenderMaskGenerator
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
        bufferStore.matrixPalettes.upload(data: &scene.palettes)
        bufferStore.ambientLights.upload(data: &scene.ambientLights)
        bufferStore.omniLights.upload(data: &scene.omniLights)
        bufferStore.directionalLights.upload(data: &scene.directionalLights)
        bufferStore.spotLights.upload(data: &scene.spotLights)
        bufferStore.cameras.upload(data: &scene.cameraUniforms)
        bufferStore.modelCoordinateSystems.upload(data: &scene.uniforms)
        renderingCoordinator.draw(frameSupply: PNFrameSupply(scene: scene,
                                                             bufferStore: bufferStore,
                                                             mask: renderMaskGenerator.generate(scene: scene)))
    }
}
