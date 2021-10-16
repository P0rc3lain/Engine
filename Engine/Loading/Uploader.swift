//
//  Uploader.swift
//  Engine
//
//  Created by Mateusz Stompór on 14/10/2021.
//

import Metal

public class Uploader {
    // MARK: - Properties
    private let device: MTLDevice
    // MARK: - Initialization
    public init(device: MTLDevice) {
        self.device = device
    }
    // MARK: - Public
    public func upload(scene: RamSceneDescription) -> GPUSceneDescription? {
        return scene.upload(device: device)
    }
}
