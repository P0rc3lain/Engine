//
//  Copyright © 2022 Mateusz Stompór. All rights reserved.
//

import Foundation

struct PNIPaletteGenerator: PNPaletteGenerator {
    func palettes(scene: PNSceneDescription) -> (palettes: [PNBLTransform], offsets: [Int]) {
        var offsets = [Int]()
        var palettes = [PNBLTransform]()
        for index in scene.animatedModels.indices {
            let palette = generatePalette(objectIndex: index, scene: scene)
            offsets.append(scene.palettes.count)
            palettes.append(contentsOf: palette)
        }
        return (palettes: palettes, offsets: offsets)
    }
    func generatePalette(objectIndex objectIdx: Int, scene: PNSceneDescription) -> [PNBLTransform] {
        let skeletonIdx = scene.animatedModels[objectIdx].skeleton
        let skeleton = scene.skeletons[skeletonIdx]
        let date = Date().timeIntervalSince1970
        guard let animation = skeleton.animations.first else {
            return []
        }
        let transformations = animation.localTransformation(at: date, interpolator: PNIInterpolator())
        return skeleton.calculatePose(animationPose: transformations)
    }
}
