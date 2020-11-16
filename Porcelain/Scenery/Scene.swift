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
    let sceneAsset: SceneAsset
    public var camera: Camera
    public var omniLights = [OmniLight]()
    public var objects = [PositionedPiece]()
    // MARK: - Initialization
    init(camera: Camera, sceneAsset: SceneAsset) {
        self.camera = camera
        self.sceneAsset = sceneAsset
    }
}
