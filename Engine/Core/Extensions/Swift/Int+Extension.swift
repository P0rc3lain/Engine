//
//  Copyright © 2021 Mateusz Stompór. All rights reserved.
//

extension Int {
    public static var `nil`: Int {
        -1
    }
    public var inclusiveON: ClosedRange<Int> {
        // inclusive range from 0 to N
        0 ... self
    }
    public var exclusiveON: Range<Int> {
        // exclusive range from 0 to N
        0 ..< self
    }
}
