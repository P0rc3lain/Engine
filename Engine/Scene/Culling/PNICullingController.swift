//
//  Copyright © 2021 Mateusz Stompór. All rights reserved.
//

import MetalBinding

struct PNICullingController: PNCullingController {
    private let interactor: PNIBoundingBoxInteractor
    init(interactor: PNIBoundingBoxInteractor) {
        self.interactor = interactor
    }
    func cullingMask(scene: PNSceneDescription,
                     boundingBox: PNWBoundingBox) -> [Bool] {
        scene.boundingBoxes.indices.map {
            interactor.overlap(scene.boundingBoxes[$0], boundingBox)
        }
    }
}
