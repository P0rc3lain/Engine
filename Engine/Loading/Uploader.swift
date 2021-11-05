//
//  Copyright © 2021 Mateusz Stompór. All rights reserved.
//

import Metal

public class Uploader {
    private let device: MTLDevice
    public init(device: MTLDevice) {
        self.device = device
    }
    public func upload(scene: RamSceneDescription) -> GPUSceneDescription? {
        scene.upload(device: device)
    }
}
