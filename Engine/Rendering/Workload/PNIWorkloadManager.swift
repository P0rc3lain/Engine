//
//  Copyright © 2021 Mateusz Stompór. All rights reserved.
//

struct PNIWorkloadManager: PNWorkloadManager {
    private var bufferStore: BufferStore
    private var renderingCoordinator: PNRenderingCoordinator
    mutating func draw(sceneGraph: inout PNScene) {
        let transcriber = PNITranscriber(transformCalculator: PNITransformCalculator(interpolator: PNIInterpolator()))
        var scene = transcriber.transcribe(scene: sceneGraph)
        bufferStore.matrixPalettes.upload(data: &scene.palettes)
        bufferStore.ambientLights.upload(data: &scene.ambientLights)
        bufferStore.omniLights.upload(data: &scene.omniLights)
        bufferStore.directionalLights.upload(data: &scene.directionalLights)
        bufferStore.spotLights.upload(data: &scene.spotLights)
        bufferStore.upload(camera: &scene.cameras[scene.entities[scene.activeCameraIdx].data.referenceIdx],
                           index: scene.activeCameraIdx)
        bufferStore.modelCoordinateSystems.upload(data: &scene.uniforms)
        renderingCoordinator.draw(scene: &scene, bufferStore: &bufferStore)
    }
}
