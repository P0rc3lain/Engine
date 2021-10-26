//
//  Copyright © 2021 Mateusz Stompór. All rights reserved.
//

import ModelIO
import simd

public struct SkeletalAnimation {
    // MARK: - Properties
    public var translations: AnimatedFloat3Array
    public var rotations: AnimatedQuatfArray
    public var scales: AnimatedFloat3Array
    // MARK: - Initialization
    public init(translations: AnimatedFloat3Array,
                rotations: AnimatedQuatfArray,
                scales: AnimatedFloat3Array) {
        self.translations = translations
        self.rotations = rotations
        self.scales = scales
    }
    func localTransformation(at time: TimeInterval) -> [simd_float4x4] {
        var localTransformations = [simd_float4x4]()
        let translation = translations.interpolated(at: time)
        let rotation = rotations.interpolated(at: time)
        let scale = scales.interpolated(at: time)
        for index in translation.indices {
            let composed = simd_float4x4.compose(translation: translation[index],
                                                 rotation: rotation[index],
                                                 scale: scale[index])
            localTransformations.append(composed)
        }
        return localTransformations
    }
}
