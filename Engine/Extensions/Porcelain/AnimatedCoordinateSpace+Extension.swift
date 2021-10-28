//
//  Copyright © 2021 Mateusz Stompór. All rights reserved.
//

import simd

extension AnimatedCoordinateSpace {
    func transformation(at time: TimeInterval) -> simd_float4x4 {
        simd_float4x4.compose(translation: translation.interpolated(at: time),
                              rotation: rotation.interpolated(at: time),
                              scale: scale.interpolated(at: time))
    }
    static public var `static`: TransformAnimation {
        TransformAnimation(translation: .defaultTranslation,
                           rotation: .defaultOrientation,
                           scale: .defaultScale)
    }
    static public func `static`(from transformation: simd_float4x4) -> TransformAnimation {
        let decomposed = transformation.decomposed
        return TransformAnimation(translation: AnimatedFloat3.static(from: decomposed.translation),
                                  rotation: AnimatedQuatf.static(from: decomposed.rotation),
                                  scale: AnimatedFloat3.static(from: decomposed.scale))
    }
}
