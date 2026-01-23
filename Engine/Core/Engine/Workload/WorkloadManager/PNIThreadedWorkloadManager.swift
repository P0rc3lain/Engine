//
//  Copyright © 2022 Mateusz Stompór. All rights reserved.
//

import PNShared

/// A multi-threaded rendering process coordinator.
public class PNIThreadedWorkloadManager: PNWorkloadManager {
    private var renderingCoordinator: PNRenderingCoordinator
    private let transcriber: PNTranscriber
    private let renderMaskGenerator: PNRenderMaskGenerator
    private let dispatchQueue = DispatchQueue.global()
    private let dispatchGroup = DispatchGroup()
    private let nodeUpdate = PNNodeUpdater()
    private var frameSupplies: PNIBufferedValue<PNFrameSupply>
    private var previousFrameScene: PNSceneDescription?
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
            let backgroundUpdateInterval = psignposter.beginInterval("Background update")
            taskQueue.execute()
            nodeUpdate.update(rootNode: sceneGraph.rootNode)
            let scene = transcriber.transcribe(scene: sceneGraph)
            let bbs = (0 ..< scene.boundingBoxes.count).compactMap {
                if scene.entities[$0].data.type == .mesh {
                    return scene.boundingBoxes[$0]
                }
                return nil
            } .map { asVertices(bb: $0) }.reduce(+)!
            let inactive = frameSupplies.pullInactive
            inactive.bufferStore.boundingBoxes.upload(data: bbs)
            inactive.bufferStore.matrixPalettes.upload(data: scene.palettes)
            inactive.bufferStore.ambientLights.upload(data: scene.ambientLights)
            inactive.bufferStore.omniLights.upload(data: scene.omniLights)
            inactive.bufferStore.directionalLights.upload(data: scene.directionalLights)
            inactive.bufferStore.spotLights.upload(data: scene.spotLights)
            inactive.bufferStore.cameras.upload(data: scene.cameraUniforms)
            inactive.bufferStore.modelCoordinateSystems.upload(data: scene.uniforms)
            let previous = previousFrameScene ?? scene
            inactive.bufferStore.previousMatrixPalettes.upload(data: previous.palettes)
            inactive.bufferStore.previousModelCoordinateSystems.upload(data: previous.uniforms)
            let supply = PNFrameSupply(scene: scene,
                                       bufferStore: inactive.bufferStore,
                                       mask: renderMaskGenerator.generate(scene: scene))
            frameSupplies.push(supply)
            previousFrameScene = scene
            psignposter.endInterval("Background update", backgroundUpdateInterval)
            dispatchGroup.leave()
        }
        renderingCoordinator.draw(frameSupply: frameSupplies.pull)
        dispatchGroup.wait()
        frameSupplies.swap()
    }
    private func asVertices(bb: PNBoundingBox) -> [VertexP] {
        [
            
        VertexP(position: bb.cornersLower.columns.0.xyz),
        VertexP(position: bb.cornersLower.columns.1.xyz),
        
        VertexP(position: bb.cornersLower.columns.1.xyz),
        VertexP(position: bb.cornersLower.columns.3.xyz),
         
        VertexP(position: bb.cornersLower.columns.1.xyz),
        VertexP(position: bb.cornersLower.columns.2.xyz),
         
        VertexP(position: bb.cornersLower.columns.2.xyz),
        VertexP(position: bb.cornersLower.columns.3.xyz),
        
        VertexP(position: bb.cornersLower.columns.2.xyz),
        VertexP(position: bb.cornersLower.columns.0.xyz),
         
        VertexP(position: bb.cornersLower.columns.3.xyz),
        VertexP(position: bb.cornersLower.columns.0.xyz),
        
        VertexP(position: bb.cornersUpper.columns.0.xyz),
        VertexP(position: bb.cornersLower.columns.0.xyz),
        
        VertexP(position: bb.cornersUpper.columns.1.xyz),
        VertexP(position: bb.cornersLower.columns.1.xyz),
        
        VertexP(position: bb.cornersUpper.columns.2.xyz),
        VertexP(position: bb.cornersLower.columns.2.xyz),
        
        VertexP(position: bb.cornersUpper.columns.3.xyz),
        VertexP(position: bb.cornersLower.columns.3.xyz),
         
         
         VertexP(position: bb.cornersUpper.columns.0.xyz),
         VertexP(position: bb.cornersUpper.columns.1.xyz),
         
         VertexP(position: bb.cornersUpper.columns.1.xyz),
         VertexP(position: bb.cornersUpper.columns.3.xyz),
          
         VertexP(position: bb.cornersUpper.columns.1.xyz),
         VertexP(position: bb.cornersUpper.columns.2.xyz),
          
         VertexP(position: bb.cornersUpper.columns.2.xyz),
         VertexP(position: bb.cornersUpper.columns.3.xyz),
         
         VertexP(position: bb.cornersUpper.columns.2.xyz),
         VertexP(position: bb.cornersUpper.columns.0.xyz),
          
         VertexP(position: bb.cornersUpper.columns.3.xyz),
         VertexP(position: bb.cornersUpper.columns.0.xyz)
        ]
    }
}
