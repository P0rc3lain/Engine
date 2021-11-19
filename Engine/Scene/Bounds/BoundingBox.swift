//
//  Copyright © 2021 Mateusz Stompór. All rights reserved.
//

import simd

struct BoundingBox: Equatable {
    let cornersLower: simd_float4x4
    let cornersUpper: simd_float4x4
    var corners: [simd_float3] {
        [cornersLower.columns.0.xyz,
         cornersLower.columns.1.xyz,
         cornersLower.columns.2.xyz,
         cornersLower.columns.3.xyz,
         cornersUpper.columns.0.xyz,
         cornersUpper.columns.1.xyz,
         cornersUpper.columns.2.xyz,
         cornersUpper.columns.3.xyz]
    }
    init(cornersLower: simd_float4x4,
         cornersUpper: simd_float4x4) {
        self.cornersLower = cornersLower
        self.cornersUpper = cornersUpper
    }
    init(corners: [simd_float3]) {
        assert(corners.count == 8, "Each point of the bounding box must be defined")
        self.init(cornersLower: simd_float4x4(simd_float4(corners[0].x, corners[0].y, corners[0].z, 1),
                                              simd_float4(corners[1].x, corners[1].y, corners[1].z, 1),
                                              simd_float4(corners[2].x, corners[2].y, corners[2].z, 1),
                                              simd_float4(corners[3].x, corners[3].y, corners[3].z, 1)),
                  cornersUpper: simd_float4x4(simd_float4(corners[4].x, corners[4].y, corners[4].z, 1),
                                              simd_float4(corners[5].x, corners[5].y, corners[5].z, 1),
                                              simd_float4(corners[6].x, corners[6].y, corners[6].z, 1),
                                              simd_float4(corners[7].x, corners[7].y, corners[7].z, 1)))
    }
    func merge(_ boundingBox: BoundingBox) -> BoundingBox {
        BoundingBox.from(bound: bound.merge(boundingBox.bound))
    }
    static func from(bound: Bound) -> BoundingBox {
        BoundingBox(cornersLower: simd_float4x4(simd_float4(bound.min.x, bound.min.y, bound.min.z, 1),
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
    var bound: Bound {
        let minX = min(cornersLower.columns.0.x,
                       cornersLower.columns.1.x,
                       cornersLower.columns.2.x,
                       cornersLower.columns.3.x,
                       cornersUpper.columns.0.x,
                       cornersUpper.columns.1.x,
                       cornersUpper.columns.2.x,
                       cornersUpper.columns.3.x)
        let maxX = max(cornersLower.columns.0.x,
                       cornersLower.columns.1.x,
                       cornersLower.columns.2.x,
                       cornersLower.columns.3.x,
                       cornersUpper.columns.0.x,
                       cornersUpper.columns.1.x,
                       cornersUpper.columns.2.x,
                       cornersUpper.columns.3.x)
        let minY = min(cornersLower.columns.0.y,
                       cornersLower.columns.1.y,
                       cornersLower.columns.2.y,
                       cornersLower.columns.3.y,
                       cornersUpper.columns.0.y,
                       cornersUpper.columns.1.y,
                       cornersUpper.columns.2.y,
                       cornersUpper.columns.3.y)
        let maxY = max(cornersLower.columns.0.y,
                       cornersLower.columns.1.y,
                       cornersLower.columns.2.y,
                       cornersLower.columns.3.y,
                       cornersUpper.columns.0.y,
                       cornersUpper.columns.1.y,
                       cornersUpper.columns.2.y,
                       cornersUpper.columns.3.y)
        let minZ = min(cornersLower.columns.0.z,
                       cornersLower.columns.1.z,
                       cornersLower.columns.2.z,
                       cornersLower.columns.3.z,
                       cornersUpper.columns.0.z,
                       cornersUpper.columns.1.z,
                       cornersUpper.columns.2.z,
                       cornersUpper.columns.3.z)
        let maxZ = max(cornersLower.columns.0.z,
                       cornersLower.columns.1.z,
                       cornersLower.columns.2.z,
                       cornersLower.columns.3.z,
                       cornersUpper.columns.0.z,
                       cornersUpper.columns.1.z,
                       cornersUpper.columns.2.z,
                       cornersUpper.columns.3.z)
        return Bound(min: simd_float3(minX, minY, minZ),
                     max: simd_float3(maxX, maxY, maxZ))
    }
    var aabb: BoundingBox {
        BoundingBox.from(bound: bound)
    }
    func overlap(_ boundingBox: BoundingBox) -> Bool {
        bound.overlap(boundingBox.bound)
    }
    public static func == (lhs: Self, rhs: Self) -> Bool {
        lhs.cornersLower == rhs.cornersLower &&
        lhs.cornersUpper == rhs.cornersUpper
    }
    static func projectionBounds(inverseProjection: simd_float4x4) -> BoundingBox {
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
        return (BoundingBox(cornersLower: lower, cornersUpper: upper)).aabb
    }
}
