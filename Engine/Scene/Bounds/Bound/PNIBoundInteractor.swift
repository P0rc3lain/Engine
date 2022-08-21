//
//  Copyright © 2021 Mateusz Stompór. All rights reserved.
//

public struct PNIBoundInteractor: PNBoundInteractor {
    public var zero: PNBound {
        PNBound(min: .zero, max: .zero)
    }
    public func isEqual(_ lhs: PNBound, _ rhs: PNBound) -> Bool {
        lhs.min == rhs.min && lhs.max == rhs.max
    }
    public func overlap(_ lhs: PNBound, _ rhs: PNBound) -> Bool {
        lhs.max.x > rhs.min.x &&
        lhs.min.x < rhs.max.x &&
        lhs.max.y > rhs.min.y &&
        lhs.min.y < rhs.max.y &&
        lhs.max.z > rhs.min.z &&
        lhs.min.z < rhs.max.z
    }
    public func merge(_ lhs: PNBound, rhs: PNBound) -> PNBound {
        PNBound(min: [min(lhs.min.x, rhs.min.x),
                      min(lhs.min.y, rhs.min.y),
                      min(lhs.min.z, rhs.min.z)],
                max: [max(lhs.max.x, rhs.max.x),
                      max(lhs.max.y, rhs.max.y),
                      max(lhs.max.z, rhs.max.z)])
    }
    public func intersect(_ bound: PNBound, ray: PNRay) -> Bool {
        let minX = (bound.min.x - ray.origin.x) * ray.inverseDirection.x
        let maxX = (bound.max.x - ray.origin.x) * ray.inverseDirection.x
        let minY = (bound.min.y - ray.origin.y) * ray.inverseDirection.y
        let maxY = (bound.max.y - ray.origin.y) * ray.inverseDirection.y
        let minZ = (bound.min.z - ray.origin.z) * ray.inverseDirection.z
        let maxZ = (bound.max.z - ray.origin.z) * ray.inverseDirection.z
        let tMin = max(max(min(minX, maxX), min(minY, maxY)), min(minZ, maxZ))
        let tMax = min(min(max(minX, maxX), max(minY, maxY)), max(minZ, maxZ))
        return tMax < 0 ? false : tMin <= tMax
    }
    public static var `default`: PNBoundInteractor {
        PNIBoundInteractor()
    }
}
