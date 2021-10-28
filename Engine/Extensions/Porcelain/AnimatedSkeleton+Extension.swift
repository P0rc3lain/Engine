//
//  Copyright © 2021 Mateusz Stompór. All rights reserved.
//

import simd

extension AnimatedSkeleton {
    func localTransformation(at time: TimeInterval) -> [simd_float4x4] {
        let translationsPalette = translation.interpolated(at: time)
        let rotationsPalette = rotation.interpolated(at: time)
        let scalesPalette = scale.interpolated(at: time)
        return translationsPalette.indices.map { index in
            simd_float4x4.compose(translation: translationsPalette[index],
                                  rotation: rotationsPalette[index],
                                  scale: scalesPalette[index])
        }
    }
}
