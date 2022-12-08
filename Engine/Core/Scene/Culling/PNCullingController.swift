//
//  Copyright © 2021 Mateusz Stompór. All rights reserved.
//

protocol PNCullingController {
    func cullingMask(scene: PNSceneDescription,
                     boundingBox: PNWBoundingBox) -> [Bool]
}
