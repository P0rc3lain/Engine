//
//  Copyright © 2021 Mateusz Stompór. All rights reserved.
//

protocol PNBoundInteractor {
    var zero: PNBound { get }
    func overlap(_ lhs: PNBound, _ rhs: PNBound) -> Bool
    func merge(_ lhs: PNBound, rhs: PNBound) -> PNBound
    func isEqual(_ lhs: PNBound, _ rhs: PNBound) -> Bool
}
