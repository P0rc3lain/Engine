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
    static func cullingMask(arrangement: inout Arrangement, worldBoundingBox: PNBoundingBox) -> [Bool] {
        var mask = [Bool](minimalCapacity: arrangement.worldPositions.count)
        let interactor = PNIBoundingBoxInteractor.default
        for i in arrangement.worldBoundingBoxes.indices {
            mask.append(interactor.overlap(arrangement.worldBoundingBoxes[i], worldBoundingBox))
        }
        return mask
    }
}
