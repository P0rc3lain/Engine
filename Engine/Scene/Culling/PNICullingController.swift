//
//  Copyright © 2021 Mateusz Stompór. All rights reserved.
//

import MetalBinding

struct PNICullingController: PNCullingController {
    private let interactor: PNBoundingBoxInteractor
    init(interactor: PNBoundingBoxInteractor) {
        self.interactor = interactor
    }
    func cullingMask(scene: PNSceneDescription,
                     boundingBox: PNWBoundingBox) -> [Bool] {
        scene.boundingBoxes.indices.map {
            if let box = scene.boundingBoxes[$0] {
                return interactor.overlap(box, boundingBox)
            } else {
                return true
            }
        }
    }
}
