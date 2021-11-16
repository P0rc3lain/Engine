//
//  Copyright © 2021 Mateusz Stompór. All rights reserved.
//

import MetalBinding

struct CullingController {
    let camera: Camera
    let cameraIdx: Int
    init(camera: Camera, cameraIdx: Int) {
        self.camera = camera
        self.cameraIdx = cameraIdx
    }
    static func cullingMask(arrangement: inout Arrangement, worldBoundingBox: BoundingBox) -> [Bool] {
        var mask = [Bool](minimalCapacity: arrangement.worldPositions.count)
        for i in arrangement.worldBoundingBoxes.indices {
            mask.append(arrangement.worldBoundingBoxes[i].overlap(worldBoundingBox))
        }
        return mask
    }
}
