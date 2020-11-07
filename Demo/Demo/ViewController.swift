//
//  ViewController.swift
//  Demo
//
//  Created by Mateusz Stompór on 05/11/2020.
//

import Cocoa
import ModelIO
import MetalKit
import Porcelain

class ViewController: NSViewController, MTKViewDelegate {
    // MARK: - Private
    private var renderer: Renderer!
    private var metalView: MTKView!
    private var scene: Scene!
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupMetalView()
        scene = buildScene()
        renderer = Renderer(view: metalView, drawableSize: metalView.drawableSize)
    }
    override func viewDidAppear() {
        super.viewDidAppear()
    }
    // MARK: - Private
    private func loadMeshes() -> [MTKMesh] {
        let asset = ModelLoader(device: metalView.device!).loadAsset(name: "Temple", extension: "obj")!
        asset.loadTextures()
        return try! MTKMesh.newMeshes(asset: asset, device: metalView.device!).metalKitMeshes
    }
    private func buildScene() -> Scene! {
        let cameraCoordinateSpace = CoordinateSpace(rotation: simd_quatf(), translation: simd_float3(), scale: simd_float3(2, 2, 2))
        let camera = Camera(nearPlane: 0.0001,
                            farPlane: 10000,
                            fovRadians: Float.radians(120),
                            aspectRation: 16/9, coordinateSpace: cameraCoordinateSpace)
        let meshes = loadMeshes()
        return Scene(camera: camera, meshes: meshes)
    }
    private func setupMetalView() {
        metalView = view as? MTKView
        metalView.delegate = self
        metalView.colorPixelFormat = .bgra8Unorm
        metalView.framebufferOnly = true
        metalView.preferredFramesPerSecond = 1000
        metalView.device = MTLCreateSystemDefaultDevice()
    }
    // MARK: - MTKViewDelegate
    func mtkView(_ view: MTKView, drawableSizeWillChange size: CGSize) {
        renderer = Renderer(view: metalView, drawableSize: size)
    }
    func draw(in view: MTKView) {
        renderer.draw(scene: &scene)
    }
}
