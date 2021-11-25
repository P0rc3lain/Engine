//
//  Copyright © 2021 Mateusz Stompór. All rights reserved.
//

import MetalKit

public class PNIEngine: PNEngine {
    private let view: MTKView
    private let coordinatorFactory: PNRenderingCoordinatorFactory
    private var coordinator: PNRenderingCoordinator
    public var scene: PNScene
    private var workloadManager: PNWorkloadManager
    public init?(view: MTKView,
                 renderingSize: CGSize,
                 scene: PNScene,
                 coordinatorFactory: PNRenderingCoordinatorFactory,
                 workloadManager: PNWorkloadManager) {
        guard let coordinator = coordinatorFactory.new(drawableSize: renderingSize) else {
            return nil
        }
        self.view = view
        self.coordinator = coordinator
        self.coordinatorFactory = coordinatorFactory
        self.scene = scene
        self.workloadManager = workloadManager
    }
    public func update(drawableSize: CGSize) -> Bool {
        guard let updated = coordinatorFactory.new(drawableSize: drawableSize) else {
            return false
        }
        coordinator = updated
        return true
    }
    public func draw() {
        workloadManager.draw(sceneGraph: &scene)
    }
}
