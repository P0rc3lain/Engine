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
    public var environmentMap: MTLTexture
    public var camera: Camera
    public var omniLights = [OmniLight]()
    public var meshes = [MTKMesh]()
    // MARK: - Initialization
    public init(camera: Camera, environmentMap: MTLTexture) {
        self.camera = camera
        self.environmentMap = environmentMap
    }
}
