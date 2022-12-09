//
//  Copyright © 2022 Mateusz Stompór. All rights reserved.
//

import Foundation

protocol PNPaletteGenerator {
    func palettes(scene: PNSceneDescription) -> (palettes: [PNBLTransform], offsets: [Int])
    func generatePalette(objectIndex: PNIndex, scene: PNSceneDescription) -> [PNBLTransform]
}
