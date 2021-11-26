//
//  Copyright © 2021 Mateusz Stompór. All rights reserved.
//

public struct PNIWorkloadManager: PNWorkloadManager {
    private var bufferStore: BufferStore
    private var renderingCoordinator: PNRenderingCoordinator
    private let renderMaskGenerator: PNRenderMaskGenerator
    public init(bufferStore: BufferStore,
                renderingCoordinator: PNRenderingCoordinator,
                renderMaskGenerator: PNRenderMaskGenerator) {
        self.bufferStore = bufferStore
        self.renderingCoordinator = renderingCoordinator
        self.renderMaskGenerator = renderMaskGenerator
    }
    public mutating func draw(sceneGraph: inout PNScene) {
        let transcriber = PNITranscriber(transformCalculator: PNITransformCalculator(interpolator: PNIInterpolator()))
        let scene = transcriber.transcribe(scene: sceneGraph)
        bufferStore.matrixPalettes.upload(data: &scene.palettes)
        bufferStore.ambientLights.upload(data: &scene.ambientLights)
        bufferStore.omniLights.upload(data: &scene.omniLights)
        bufferStore.directionalLights.upload(data: &scene.directionalLights)
        bufferStore.spotLights.upload(data: &scene.spotLights)
        bufferStore.upload(camera: &scene.cameras[scene.entities[scene.activeCameraIdx].data.referenceIdx],
                           index: scene.activeCameraIdx)
        bufferStore.modelCoordinateSystems.upload(data: &scene.uniforms)
        renderingCoordinator.draw(frameSupply: PNFrameSupply(scene: scene,
                                                             bufferStore: bufferStore,
                                                             mask: renderMaskGenerator.generate(scene: scene)))
    }
}
