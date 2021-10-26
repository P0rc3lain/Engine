//
//  Copyright © 2021 Mateusz Stompór. All rights reserved.
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
        scene.upload(device: device)
    }
}
