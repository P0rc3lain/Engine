//
//  Engine.swift
//  Engine
//
//  Created by Mateusz Stompór on 11/11/2020.
//

import MetalKit

public class Engine {
    // MARK: - Properties
    private let view: MTKView
    public var sceneDescription: GPUSceneDescription
    private var coordinator: RenderingCoordinator
    // MARK: - Initialization
    public init?(view: MTKView, renderingSize: CGSize, sceneDescription: GPUSceneDescription) {
        guard let coordinator = RenderingCoordinator(view: view,
                                                     canvasSize: view.drawableSize,
                                                     renderingSize: renderingSize) else {
            return nil
        }
        self.view = view
        self.coordinator = coordinator
        self.sceneDescription = sceneDescription
    }
    // MARK: - Public
    public func updateDrawableSize(drawableSize: CGSize) -> Bool {
        guard let updated = RenderingCoordinator(view: view, canvasSize: drawableSize, renderingSize: coordinator.renderingSize) else {
            return false
        }
        coordinator = updated
        return true
    }
    public func draw() {
        coordinator.draw(scene: &sceneDescription)
    }
}
