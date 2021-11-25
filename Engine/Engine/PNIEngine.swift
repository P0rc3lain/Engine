//
//  Copyright © 2021 Mateusz Stompór. All rights reserved.
//

import MetalKit

public class PNIEngine: PNEngine {
    private let view: MTKView
    public var scene: PNScene
    private var coordinator: RenderingCoordinator
    public init?(view: MTKView, renderingSize: CGSize, scene: PNScene) {
        guard let coordinator = RenderingCoordinator(view: view,
                                                     renderingSize: renderingSize) else {
            return nil
        }
        self.view = view
        self.coordinator = coordinator
        self.scene = scene
    }
    public func update(drawableSize: CGSize) -> Bool {
        guard let updated = RenderingCoordinator(view: view,
                                                 renderingSize: drawableSize) else {
            return false
        }
        coordinator = updated
        return true
    }
    public func draw() {
        coordinator.draw(sceneGraph: &scene)
    }
}
