//
//  Scene.swift
//  Porcelain
//
//  Created by Mateusz Stompór on 07/11/2020.
//

import MetalKit
import Foundation

public struct Scene {
    // MARK: - Properties
    public let camera: Camera
    public var meshes: [MTKMesh]
    // MARK: - Initialization
    public init(camera: Camera, meshes: [MTKMesh]) {
        self.camera = camera
        self.meshes = meshes
    }
}
