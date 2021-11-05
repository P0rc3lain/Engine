//
//  Copyright © 2021 Mateusz Stompór. All rights reserved.
//

import ModelIO
import simd

public struct TransformAnimation {
    public var translation: AnimatedFloat3
    public var scale: AnimatedFloat3
    public var rotation: AnimatedQuatf
    public init(translation: AnimatedFloat3, rotation: AnimatedQuatf, scale: AnimatedFloat3) {
        self.translation = translation
        self.rotation = rotation
        self.scale = scale
    }
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
