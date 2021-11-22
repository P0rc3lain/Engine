//
//  Copyright © 2021 Mateusz Stompór. All rights reserved.
//

import simd

struct PNIBoundingBoxInteractor: PNBoundingBoxInteractor {
    private let boundInteractor: PNBoundInteractor
    init(boundInteractor: PNBoundInteractor) {
        self.boundInteractor = boundInteractor
    }
    func corners(_ bound: PNBoundingBox) -> [simd_float3] {
        [bound.cornersLower.columns.0.xyz,
         bound.cornersLower.columns.1.xyz,
         bound.cornersLower.columns.2.xyz,
         bound.cornersLower.columns.3.xyz,
         bound.cornersUpper.columns.0.xyz,
         bound.cornersUpper.columns.1.xyz,
         bound.cornersUpper.columns.2.xyz,
         bound.cornersUpper.columns.3.xyz]
    }
    func isEqual(_ lhs: PNBoundingBox, _ rhs: PNBoundingBox) -> Bool {
        boundInteractor.isEqual(bound(lhs), bound(rhs))
    }
    func multiply(_ lhs: simd_float4x4, _ rhs: PNBoundingBox) -> PNBoundingBox {
        PNBoundingBox(cornersLower: lhs * rhs.cornersLower,
                      cornersUpper: lhs * rhs.cornersUpper)
    }
    func bound(_ boundingBox: PNBoundingBox) -> PNBound {
        let minX = min(boundingBox.cornersLower.columns.0.x,
                       boundingBox.cornersLower.columns.1.x,
                       boundingBox.cornersLower.columns.2.x,
                       boundingBox.cornersLower.columns.3.x,
                       boundingBox.cornersUpper.columns.0.x,
                       boundingBox.cornersUpper.columns.1.x,
                       boundingBox.cornersUpper.columns.2.x,
                       boundingBox.cornersUpper.columns.3.x)
        let maxX = max(boundingBox.cornersLower.columns.0.x,
                       boundingBox.cornersLower.columns.1.x,
                       boundingBox.cornersLower.columns.2.x,
                       boundingBox.cornersLower.columns.3.x,
                       boundingBox.cornersUpper.columns.0.x,
                       boundingBox.cornersUpper.columns.1.x,
                       boundingBox.cornersUpper.columns.2.x,
                       boundingBox.cornersUpper.columns.3.x)
        let minY = min(boundingBox.cornersLower.columns.0.y,
                       boundingBox.cornersLower.columns.1.y,
                       boundingBox.cornersLower.columns.2.y,
                       boundingBox.cornersLower.columns.3.y,
                       boundingBox.cornersUpper.columns.0.y,
                       boundingBox.cornersUpper.columns.1.y,
                       boundingBox.cornersUpper.columns.2.y,
                       boundingBox.cornersUpper.columns.3.y)
        let maxY = max(boundingBox.cornersLower.columns.0.y,
                       boundingBox.cornersLower.columns.1.y,
                       boundingBox.cornersLower.columns.2.y,
                       boundingBox.cornersLower.columns.3.y,
                       boundingBox.cornersUpper.columns.0.y,
                       boundingBox.cornersUpper.columns.1.y,
                       boundingBox.cornersUpper.columns.2.y,
                       boundingBox.cornersUpper.columns.3.y)
        let minZ = min(boundingBox.cornersLower.columns.0.z,
                       boundingBox.cornersLower.columns.1.z,
                       boundingBox.cornersLower.columns.2.z,
                       boundingBox.cornersLower.columns.3.z,
                       boundingBox.cornersUpper.columns.0.z,
                       boundingBox.cornersUpper.columns.1.z,
                       boundingBox.cornersUpper.columns.2.z,
                       boundingBox.cornersUpper.columns.3.z)
        let maxZ = max(boundingBox.cornersLower.columns.0.z,
                       boundingBox.cornersLower.columns.1.z,
                       boundingBox.cornersLower.columns.2.z,
                       boundingBox.cornersLower.columns.3.z,
                       boundingBox.cornersUpper.columns.0.z,
                       boundingBox.cornersUpper.columns.1.z,
                       boundingBox.cornersUpper.columns.2.z,
                       boundingBox.cornersUpper.columns.3.z)
        return PNBound(min: simd_float3(minX, minY, minZ),
                       max: simd_float3(maxX, maxY, maxZ))
    }
    func aabb(_ boundingBox: PNBoundingBox) -> PNBoundingBox {
        from(bound: bound(boundingBox))
    }
    func merge(_ lhs: PNBoundingBox, _ rhs: PNBoundingBox) -> PNBoundingBox {
        from(bound: boundInteractor.merge(bound(lhs), rhs: bound(rhs)))
    }
    func overlap(_ lhs: PNBoundingBox, _ rhs: PNBoundingBox) -> Bool {
        boundInteractor.overlap(bound(lhs), bound(rhs))
    }
    func from(bound: PNBound) -> PNBoundingBox {
        PNBoundingBox(cornersLower: simd_float4x4(simd_float4(bound.min.x, bound.min.y, bound.min.z, 1),
                                                  simd_float4(bound.max.x, bound.min.y, bound.min.z, 1),
                                                  simd_float4(bound.min.x, bound.min.y, bound.max.z, 1),
                                                  simd_float4(bound.max.x, bound.min.y, bound.max.z, 1)
                                                 ),
                      cornersUpper: simd_float4x4(simd_float4(bound.min.x, bound.max.y, bound.min.z, 1),
                                                  simd_float4(bound.max.x, bound.max.y, bound.min.z, 1),
                                                  simd_float4(bound.min.x, bound.max.y, bound.max.z, 1),
                                                  simd_float4(bound.max.x, bound.max.y, bound.max.z, 1)
                                                 ))
    }
    func from(_ corners: [simd_float3]) -> PNBoundingBox {
        assert(corners.count == 8, "Each point of the bounding box must be defined")
        return PNBoundingBox(cornersLower: simd_float4x4(simd_float4(corners[0].x, corners[0].y, corners[0].z, 1),
                                                         simd_float4(corners[1].x, corners[1].y, corners[1].z, 1),
                                                         simd_float4(corners[2].x, corners[2].y, corners[2].z, 1),
                                                         simd_float4(corners[3].x, corners[3].y, corners[3].z, 1)),
                             cornersUpper: simd_float4x4(simd_float4(corners[4].x, corners[4].y, corners[4].z, 1),
                                                         simd_float4(corners[5].x, corners[5].y, corners[5].z, 1),
                                                         simd_float4(corners[6].x, corners[6].y, corners[6].z, 1),
                                                         simd_float4(corners[7].x, corners[7].y, corners[7].z, 1)))
    }
    func from(inverseProjection: simd_float4x4) -> PNBoundingBox {
        var lower = inverseProjection * simd_float4x4(simd_float4(-1, -1, 0, 1),
                                                      simd_float4(1, -1, 0, 1),
                                                      simd_float4(-1, -1, 1, 1),
                                                      simd_float4(1, -1, 1, 1))
        var upper = inverseProjection * simd_float4x4(simd_float4(-1, 1, 0, 1),
                                                      simd_float4(1, 1, 0, 1),
                                                      simd_float4(-1, 1, 1, 1),
                                                      simd_float4(1, 1, 1, 1))
        // Lower
        lower.columns.0 /= lower.columns.0.w
        lower.columns.1 /= lower.columns.1.w
        lower.columns.2 /= lower.columns.2.w
        lower.columns.3 /= lower.columns.3.w
        // Upper
        upper.columns.0 /= upper.columns.0.w
        upper.columns.1 /= upper.columns.1.w
        upper.columns.2 /= upper.columns.2.w
        upper.columns.3 /= upper.columns.3.w
        return aabb(PNBoundingBox(cornersLower: lower, cornersUpper: upper))
    }
    static var `default`: PNIBoundingBoxInteractor {
        PNIBoundingBoxInteractor(boundInteractor: PNIBoundInteractor())
    }
}
