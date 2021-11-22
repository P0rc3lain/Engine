//
//  Copyright © 2021 Mateusz Stompór. All rights reserved.
//

import MetalBinding

struct PNICullingController: PNCullingController {
    private let interactor: PNIBoundingBoxInteractor
    init(interactor: PNIBoundingBoxInteractor) {
        self.interactor = interactor
    }
    func cullingMask(arrangement: inout PNArrangement, boundingBox: PNWBoundingBox) -> [Bool] {
        var mask = [Bool](minimalCapacity: arrangement.positions.count)
        for i in arrangement.boundingBoxes.indices {
            mask.append(interactor.overlap(arrangement.boundingBoxes[i], boundingBox))
        }
        return mask
    }
}
