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
    public var camera: Camera
    public var omniLights = [OmniLight]()
    public var models = [ModelPiece]()
    public var environmentMap: MTLTexture
    // MARK: - Initialization
    init(camera: Camera, environmentMap: MTLTexture) {
        self.camera = camera
        self.environmentMap = environmentMap
    }
}
