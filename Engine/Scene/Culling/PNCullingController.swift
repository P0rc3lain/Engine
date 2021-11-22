//
//  Copyright © 2021 Mateusz Stompór. All rights reserved.
//

protocol PNCullingController {
    func cullingMask(arrangement: inout PNArrangement, boundingBox: PNWBoundingBox) -> [Bool]
}
