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
    public var camera: Camera
    public var omniLights = [OmniLight]()
    public var meshes = [MTKMesh]()
    // MARK: - Initialization
    public init(camera: Camera) {
        self.camera = camera
    }
}
