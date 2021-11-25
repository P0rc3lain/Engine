//
//  Copyright © 2021 Mateusz Stompór. All rights reserved.
//

import MetalKit

public class PNIEngine: PNEngine {
    private let view: MTKView
    public var scene: PNScene
    private let coordinatorFactory: PNRenderingCoordinatorFactory
    private let workloadManagerFactory: PNWorkloadManagerFactory
    private var workloadManager: PNWorkloadManager
    private var bufferStore: BufferStore
    public init?(view: MTKView,
                 renderingSize: CGSize,
                 scene: PNScene,
                 coordinatorFactory: PNRenderingCoordinatorFactory,
                 workloadManagerFactory: PNWorkloadManagerFactory) {
        guard let coordinator = coordinatorFactory.new(drawableSize: renderingSize) else {
            assert(false, "Could not create coordinator")
            return nil
        }
        self.view = view
        self.coordinatorFactory = coordinatorFactory
        self.scene = scene
        self.bufferStore = BufferStore(device: view.device!)!
        self.workloadManagerFactory = workloadManagerFactory
        self.workloadManager = workloadManagerFactory.new(bufferStore: bufferStore,
                                                          renderingCoordinator: coordinator)
    }
    public func update(drawableSize: CGSize) -> Bool {
        guard let updated = coordinatorFactory.new(drawableSize: drawableSize) else {
            return false
        }
        workloadManager = workloadManagerFactory.new(bufferStore: bufferStore,
                                                     renderingCoordinator: updated)
        return true
    }
    public func draw() {
        workloadManager.draw(sceneGraph: &scene)
    }
}
