//
//  Copyright © 2021 Mateusz Stompór. All rights reserved.
//

import simd

public protocol PNBoundingBoxInteractor {
    func aabb(_ boundingBox: PNBoundingBox) -> PNBoundingBox
    func bound(_ boundingBox: PNBoundingBox) -> PNBound
    func safeBound(_ boundingBox: PNBoundingBox?) -> PNBound?
    func merge(_ lhs: PNBoundingBox, _ rhs: PNBoundingBox) -> PNBoundingBox
    func overlap(_ lhs: PNBoundingBox, _ rhs: PNBoundingBox) -> Bool
    func from(bound: PNBound) -> PNBoundingBox
    func from(inverseProjection: simd_float4x4) -> PNBoundingBox
    func from(_ corners: [simd_float3]) -> PNBoundingBox
    func isEqual(_ lhs: PNBoundingBox, _ rhs: PNBoundingBox) -> Bool
    func multiply(_ lhs: simd_float4x4, _ rhs: PNBoundingBox) -> PNBoundingBox
    func corners(_ bound: PNBoundingBox) -> [simd_float3]
}
