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
}
