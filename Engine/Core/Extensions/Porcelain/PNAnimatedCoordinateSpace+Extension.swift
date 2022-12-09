//
//  Copyright © 2021 Mateusz Stompór. All rights reserved.
//

import simd

extension PNAnimatedCoordinateSpace {
    static public var `static`: PNAnimatedCoordinateSpace {
        PNAnimatedCoordinateSpace(translation: PNAnimatedFloat3.defaultTranslation,
                                  rotation: PNAnimatedQuatf.defaultOrientation,
                                  scale: PNAnimatedFloat3.defaultScale)
    }
    static public func `static`(from transformation: simd_float4x4) -> PNAnimatedCoordinateSpace {
        let decomposed = transformation.decomposed
        return PNAnimatedCoordinateSpace(translation: PNAnimatedFloat3.static(from: decomposed.translation),
                                         rotation: PNAnimatedQuatf.static(from: decomposed.rotation),
                                         scale: PNAnimatedFloat3.static(from: decomposed.scale))
    }
}
