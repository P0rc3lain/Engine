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
    public var scene: Scene
    private var coordinator: RenderingCoordinator
    // MARK: - Initialization
    public init(view: MTKView, renderingSize: CGSize, sceneAsset: SceneAsset) {
        self.view = view
        self.coordinator = RenderingCoordinator(view: view,
                                                canvasSize: view.drawableSize,
                                                renderingSize: renderingSize)
        let aspectRatio = Float(renderingSize.width/renderingSize.height)
        self.scene = Scene.make(cameraAspectRation: aspectRatio,
                                sceneAsset: sceneAsset)
    }
    // MARK: - Public
    public func updateDrawableSize(drawableSize: CGSize) {
        coordinator = RenderingCoordinator(view: view, canvasSize: drawableSize, renderingSize: coordinator.renderingSize)
    }
    public func draw() {
        coordinator.draw(scene: &scene)
    }
}
