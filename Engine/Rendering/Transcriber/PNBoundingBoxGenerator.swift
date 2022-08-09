//
//  Copyright © 2022 Mateusz Stompór. All rights reserved.
//

import Foundation

protocol PNBoundingBoxGenerator {
    func boundingBoxes(scene: PNSceneDescription) -> [PNBoundingBox]
}
