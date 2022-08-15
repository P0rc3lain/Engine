//
//  Copyright © 2021 Mateusz Stompór. All rights reserved.
//

struct PNIBoundInteractor: PNBoundInteractor {
    var zero: PNBound {
        PNBound(min: .zero, max: .zero)
    }
    func isEqual(_ lhs: PNBound, _ rhs: PNBound) -> Bool {
        lhs.min == rhs.min && lhs.max == rhs.max
    }
    func overlap(_ lhs: PNBound, _ rhs: PNBound) -> Bool {
        lhs.max.x > rhs.min.x &&
        lhs.min.x < rhs.max.x &&
        lhs.max.y > rhs.min.y &&
        lhs.min.y < rhs.max.y &&
        lhs.max.z > rhs.min.z &&
        lhs.min.z < rhs.max.z
    }
    func merge(_ lhs: PNBound, rhs: PNBound) -> PNBound {
        PNBound(min: [Swift.min(lhs.min.x, rhs.min.x),
                      Swift.min(lhs.min.y, rhs.min.y),
                      Swift.min(lhs.min.z, rhs.min.z)],
                max: [Swift.max(lhs.max.x, rhs.max.x),
                      Swift.max(lhs.max.y, rhs.max.y),
                      Swift.max(lhs.max.z, rhs.max.z)])
    }
    func intersect(_ bound: PNBound, ray: PNRay) -> Bool {
        let t1 = (bound.min.x - ray.origin.x) * ray.inverseDirection.x
        let t2 = (bound.max.x - ray.origin.x) * ray.inverseDirection.x
        let t3 = (bound.min.y - ray.origin.y) * ray.inverseDirection.y
        let t4 = (bound.max.y - ray.origin.y) * ray.inverseDirection.y
        let t5 = (bound.min.z - ray.origin.z) * ray.inverseDirection.z
        let t6 = (bound.max.z - ray.origin.z) * ray.inverseDirection.z
        let tmin = max(max(min(t1, t2), min(t3, t4)), min(t5, t6))
        let tmax = min(min(max(t1, t2), max(t3, t4)), max(t5, t6))
        return tmax < 0 ? false : tmin <= tmax
    }
}
