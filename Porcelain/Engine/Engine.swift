//
//  Engine.swift
//  Porcelain
//
//  Created by Mateusz Stompór on 11/11/2020.
//

import Metal
import MetalKit

public class Engine {
    // MARK: - Properties
    private let view: MTKView
    public var scene: Scene
    private var renderer: Renderer
    // MARK: - Initialization
    public init(view: MTKView) {
        self.view = view
        self.renderer = Renderer(view: view, drawableSize: view.drawableSize)
        self.scene = Engine.buildDefaultScene(view: view)
    }
    public func updateDrawableSize(drawableSize: CGSize) {
        renderer = Renderer(view: view, drawableSize: drawableSize)
    }
    public func draw() {
        renderer.draw(scene: &scene)
    }
    // MARK: - Private
    private static func buildDefaultScene(view: MTKView) -> Scene {
        let initialOrientation = simd_quatf(angle: 0, axis: simd_float3(0, 1, 0))
        let cameraCoordinateSpace = CoordinateSpace(orientation: initialOrientation, translation: simd_float3(), scale: simd_float3(1, 1, 1))
        let camera = Camera(nearPlane: 0.01,
                            farPlane: 10000,
                            fovRadians: Float.radians(80),
                            aspectRation: Float(view.drawableSize.width/view.drawableSize.height), coordinateSpace: cameraCoordinateSpace)
        return Scene(camera: camera, environmentMap: view.device!.makeSolid2DTexture(color: simd_float4())!)
    }
}
