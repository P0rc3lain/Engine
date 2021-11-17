//
//  Copyright © 2021 Mateusz Stompór. All rights reserved.
//

import simd

struct BoundingBox: Equatable {
    let corners: [simd_float3]
    init(corners: [simd_float3]) {
        assert(corners.count == 8, "Each point of the bounding box must be defined")
        self.corners = corners
    }
    func merge(_ boundingBox: BoundingBox) -> BoundingBox {
        BoundingBox.from(bound: bound.merge(boundingBox.bound))
    }
    static func from(bound: Bound) -> BoundingBox {
        var bounds = [simd_float3](minimalCapacity: 8)
        // Lower
        bounds.append([bound.min.x, bound.min.y, bound.min.z])
        bounds.append([bound.max.x, bound.min.y, bound.min.z])
        bounds.append([bound.min.x, bound.min.y, bound.max.z])
        bounds.append([bound.max.x, bound.min.y, bound.max.z])
        // Upper
        bounds.append([bound.min.x, bound.max.y, bound.min.z])
        bounds.append([bound.max.x, bound.max.y, bound.min.z])
        bounds.append([bound.min.x, bound.max.y, bound.max.z])
        bounds.append([bound.max.x, bound.max.y, bound.max.z])
        return BoundingBox(corners: bounds)
    }
    var bound: Bound {
        var minX = corners[0].x
        var maxX = corners[0].x
        var minY = corners[0].y
        var maxY = corners[0].y
        var minZ = corners[0].z
        var maxZ = corners[0].z
        for i in 1 ..< 8 {
            minX = min(minX, corners[i].x)
            maxX = max(maxX, corners[i].x)
            minY = min(minY, corners[i].y)
            maxY = max(maxY, corners[i].y)
            minZ = min(minZ, corners[i].z)
            maxZ = max(maxZ, corners[i].z)
        }
        return Bound(min: [minX, minY, minZ],
                     max: [maxX, maxY, maxZ])
    }
    var aabb: BoundingBox {
        BoundingBox.from(bound: bound)
    }
    func overlap(_ boundingBox: BoundingBox) -> Bool {
        bound.overlap(boundingBox.bound)
    }
    public static func == (lhs: Self, rhs: Self) -> Bool {
        lhs.corners == rhs.corners
    }
}
