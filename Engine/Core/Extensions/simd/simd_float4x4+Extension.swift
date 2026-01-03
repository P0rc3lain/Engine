//
//  Copyright © 2021 Mateusz Stompór. All rights reserved.
//

import simd
import ZPack

extension simd_float4x4 {
    public var decomposed: PNPosition {
        PNPosition(translation: translation,
                   rotation: rotation,
                   scale: scale)
    }
    static func orthographicProjection(bound: PNBound) -> simd_float4x4 {
        orthographicProjection(left: bound.min.x,
                               right: bound.max.x,
                               top: bound.max.y,
                               bottom: bound.min.y,
                               near: bound.min.z,
                               far: bound.max.z)
    }
}
