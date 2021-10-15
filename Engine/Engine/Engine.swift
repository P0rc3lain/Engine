//
//  Engine.swift
//  Engine
//
//  Created by Mateusz Stompór on 11/11/2020.
//

import Types
import MetalKit

public class Engine {
    // MARK: - Properties
    private let view: MTKView
    public var sceneDescription: GPUSceneDescription
    private var coordinator: RenderingCoordinator
    // MARK: - Initialization
    public init(view: MTKView, renderingSize: CGSize, sceneDescription: GPUSceneDescription) {
        self.view = view
        self.coordinator = RenderingCoordinator(view: view,
                                                canvasSize: view.drawableSize,
                                                renderingSize: renderingSize)
        self.sceneDescription = sceneDescription
    }
    // MARK: - Public
    public func updateDrawableSize(drawableSize: CGSize) {
        coordinator = RenderingCoordinator(view: view, canvasSize: drawableSize, renderingSize: coordinator.renderingSize)
    }
    public func draw() {
        coordinator.draw(scene: &sceneDescription)
    }
}
