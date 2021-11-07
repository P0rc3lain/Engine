//
//  Copyright © 2021 Mateusz Stompór. All rights reserved.
//

import MetalKit

public class Engine {
    private let view: MTKView
    public var sceneDescription: GPUSceneDescription
    private var coordinator: RenderingCoordinator
    public init?(view: MTKView, renderingSize: CGSize, sceneDescription: GPUSceneDescription) {
        guard let coordinator = RenderingCoordinator(view: view,
                                                     renderingSize: renderingSize) else {
            return nil
        }
        self.view = view
        self.coordinator = coordinator
        self.sceneDescription = sceneDescription
    }
    public func updateDrawableSize(drawableSize: CGSize) -> Bool {
        guard let updated = RenderingCoordinator(view: view,
                                                 renderingSize: drawableSize) else {
            return false
        }
        coordinator = updated
        return true
    }
    public func draw() {
        coordinator.draw(scene: &sceneDescription)
    }
}
