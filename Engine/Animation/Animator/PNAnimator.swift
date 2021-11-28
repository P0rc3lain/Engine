//
//  Copyright © 2021 Mateusz Stompór. All rights reserved.
//

public protocol PNAnimator {
    var chronometer: PNChronometer { get set }
    func transform(coordinateSpace: PNAnimatedCoordinateSpace) -> PNTransform
}
