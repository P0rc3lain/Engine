//
//  Copyright © 2022 Mateusz Stompór. All rights reserved.
//

/// A multi-threaded rendering process coordinator.
public class PNIThreadedWorkloadManager: PNWorkloadManager {
    private var renderingCoordinator: PNRenderingCoordinator
    private let transcriber: PNTranscriber
    private let renderMaskGenerator: PNRenderMaskGenerator
    private let dispatchQueue = DispatchQueue.global()
    private let dispatchGroup = DispatchGroup()
    private var frameSupplies: PNIBufferedValue<PNFrameSupply>
    public init(bufferStores: (PNBufferStore, PNBufferStore),
                renderingCoordinator: PNRenderingCoordinator,
                renderMaskGenerator: PNRenderMaskGenerator,
                transcriber: PNTranscriber) {
        self.renderingCoordinator = renderingCoordinator
        self.transcriber = transcriber
        self.renderMaskGenerator = renderMaskGenerator
        frameSupplies = PNIBufferedValue(PNFrameSupply(scene: PNSceneDescription(),
                                                       bufferStore: bufferStores.0,
                                                       mask: .empty),
                                         PNFrameSupply(scene: PNSceneDescription(),
                                                       bufferStore: bufferStores.1,
                                                       mask: .empty))
    }
    public func draw(sceneGraph: PNScene, taskQueue: PNRepeatableTaskQueue) {
        dispatchGroup.enter()
        dispatchQueue.async { [unowned self] in
            taskQueue.execute()
            let scene = transcriber.transcribe(scene: sceneGraph)
            let inactive = frameSupplies.pullInactive
            inactive.bufferStore.matrixPalettes.upload(data: scene.palettes)
            inactive.bufferStore.ambientLights.upload(data: scene.ambientLights)
            inactive.bufferStore.omniLights.upload(data: scene.omniLights)
            inactive.bufferStore.directionalLights.upload(data: scene.directionalLights)
            inactive.bufferStore.spotLights.upload(data: scene.spotLights)
            inactive.bufferStore.cameras.upload(data: scene.cameraUniforms)
            inactive.bufferStore.modelCoordinateSystems.upload(data: scene.uniforms)
            let supply = PNFrameSupply(scene: scene,
                                       bufferStore: inactive.bufferStore,
                                       mask: renderMaskGenerator.generate(scene: scene))
            frameSupplies.push(supply)
            dispatchGroup.leave()
        }
        renderingCoordinator.draw(frameSupply: frameSupplies.pull)
        dispatchGroup.wait()
        frameSupplies.swap()
    }
}
