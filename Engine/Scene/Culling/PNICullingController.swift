//
//  Copyright © 2021 Mateusz Stompór. All rights reserved.
//

import MetalBinding

struct PNICullingController: PNCullingController {
    private let interactor: PNIBoundingBoxInteractor
    init(interactor: PNIBoundingBoxInteractor) {
        self.interactor = interactor
    }
    func cullingMask(scene: inout PNSceneDescription, boundingBox: PNWBoundingBox) -> [Bool] {
        var mask = [Bool](minimalCapacity: scene.uniforms.count)
        for i in scene.boundingBoxes.indices {
            mask.append(interactor.overlap(scene.boundingBoxes[i], boundingBox))
        }
        return mask
    }
}
