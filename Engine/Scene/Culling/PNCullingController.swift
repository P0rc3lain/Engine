//
//  Copyright © 2021 Mateusz Stompór. All rights reserved.
//

protocol PNCullingController {
    func cullingMask(scene: inout PNSceneDescription, boundingBox: PNWBoundingBox) -> [Bool]
}
