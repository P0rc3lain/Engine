//
//  Copyright © 2021 Mateusz Stompór. All rights reserved.
//

public protocol PNBoundInteractor {
    func overlap(_ lhs: PNBound, _ rhs: PNBound) -> Bool
    func merge(_ lhs: PNBound, rhs: PNBound) -> PNBound
    func isEqual(_ lhs: PNBound, _ rhs: PNBound) -> Bool
    func intersect(_ bound: PNBound, ray: PNRay) -> Bool
    func width(_ bound: PNBound) -> Float
    func height(_ bound: PNBound) -> Float
    func depth(_ bound: PNBound) -> Float
    func center(_ bound: PNBound) -> PNPoint3D
}
