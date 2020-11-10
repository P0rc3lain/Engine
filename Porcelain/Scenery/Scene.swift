//
//  Scene.swift
//  Porcelain
//
//  Created by Mateusz Stompór on 07/11/2020.
//

import ModelIO
import MetalKit
import Foundation

public struct Scene {
    // MARK: - Properties
    public var materials = [Material]()
    public var textures = [Texture]()
    public var environmentMap: MTLTexture
    public var camera: Camera
    public var omniLights = [OmniLight]()
    public var models = [ModelPiece]()
    // MARK: - Initialization
    public init(camera: Camera, environmentMap: MTLTexture) {
        self.camera = camera
        self.environmentMap = environmentMap
    }
}
