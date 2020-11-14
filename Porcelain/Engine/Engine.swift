//
//  Engine.swift
//  Porcelain
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
    public init(view: MTKView) {
        self.view = view
        self.coordinator = RenderingCoordinator(view: view, drawableSize: view.drawableSize)
        self.scene = Scene.make(device: view.device!, cameraAspectRation: view.drawableSize.aspectRatio)
    }
    // MARK: - Public
    public func updateDrawableSize(drawableSize: CGSize) {
        coordinator = RenderingCoordinator(view: view, drawableSize: drawableSize)
    }
    public func draw() {
        coordinator.draw(scene: &scene)
    }
}
