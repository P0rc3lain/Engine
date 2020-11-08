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
        NSEvent.addLocalMonitorForEvents(matching: .keyDown) {
            self.keyDown(with: $0)
            return $0
        }
    }
    // MARK: - Overriden
    override func keyDown(with event: NSEvent) {
        let step: Float = 10
        super.keyDown(with: event)
        switch event.charactersIgnoringModifiers {
        case "d":
            scene.camera.coordinateSpace.translation += simd_float3(-step, 0, 0)
        case "s":
            scene.camera.coordinateSpace.translation += simd_float3(0, 0, -step)
        case "a":
            scene.camera.coordinateSpace.translation += simd_float3(step, 0, 0)
        case "w":
            scene.camera.coordinateSpace.translation += simd_float3(0, 0, step)
        case "z":
            scene.camera.coordinateSpace.translation += simd_float3(0, step, 0)
        case "x":
            scene.camera.coordinateSpace.translation += simd_float3(0, -step, 0)
        case "q":
            let q = scene.camera.coordinateSpace.orientation
            let rot = simd_quatf(angle: -Float(20).radians, axis: simd_float3(0, 1, 0))
            scene.camera.coordinateSpace.orientation = rot * q
        case "e":
            let q = scene.camera.coordinateSpace.orientation
            let rot = simd_quatf(angle: Float(20).radians, axis: simd_float3(0, 1, 0))
            scene.camera.coordinateSpace.orientation = rot * q
        case "r":
            let q = scene.camera.coordinateSpace.orientation
            let rot = simd_quatf(angle: -Float(20).radians, axis: simd_float3(1, 0, 0))
            scene.camera.coordinateSpace.orientation = rot * q
        case "t":
            let q = scene.camera.coordinateSpace.orientation
            let rot = simd_quatf(angle: Float(20).radians, axis: simd_float3(1, 0, 0))
            scene.camera.coordinateSpace.orientation = rot * q
        default:
            break
        }
    }
    // MARK: - Private
    private func loadMeshes() -> [MTKMesh] {
        let sphere = ModelLoader(device: metalView.device!).loadAsset(name: "Temple", extension: "obj")!
        return try! MTKMesh.newMeshes(asset: sphere, device: metalView.device!).metalKitMeshes
    }
    private func loadEnvironmentMap() -> MTLTexture {
        let loader = MTKTextureLoader(device: metalView.device!)
        let texture = try! loader.newTexture(name: "SkyMap", scaleFactor: 1, bundle: Bundle.main, options: nil)
        return texture
    }
    private func buildScene() -> Scene! {
        let initialOrientation = simd_quatf(angle: 0, axis: simd_float3(0, 1, 0))
        let cameraCoordinateSpace = CoordinateSpace(orientation: initialOrientation, translation: simd_float3(), scale: simd_float3(1, 1, 1))
        let camera = Camera(nearPlane: 0.01,
                            farPlane: 10000,
                            fovRadians: Float.radians(120),
                            aspectRation: 16/10, coordinateSpace: cameraCoordinateSpace)
        let meshes = loadMeshes()
        let environmentMap = loadEnvironmentMap()
        var scene = Scene(camera: camera, environmentMap: environmentMap)
        scene.meshes.append(contentsOf: meshes)
        scene.omniLights.append(OmniLight(color: simd_float3(1, 1, 0), intensity: 50, position: simd_float3(0, 20, 0)))
        return scene
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
