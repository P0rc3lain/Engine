//
//  Copyright © 2022 Mateusz Stompór. All rights reserved.
//

public struct PNPositioningRules {
    public let x: ClosedRange<Float>
    public let y: ClosedRange<Float>
    public let z: ClosedRange<Float>
    public init(x: ClosedRange<Float>,
                y: ClosedRange<Float>,
                z: ClosedRange<Float>) {
        self.x = x
        self.y = y
        self.z = z
    }
    var bound: PNBound {
        PNBound(min: [x.lowerBound,
                      y.lowerBound,
                      z.lowerBound],
                max: [x.upperBound,
                      y.upperBound,
                      z.upperBound])
    }
}
