//
//  Copyright © 2021 Mateusz Stompór. All rights reserved.
//

extension Int {
    public static var `nil`: Int {
        -1
    }
    var naturalInclusive: ClosedRange<Int> {
        0 ... self
    }
    var naturalExclusive: Range<Int> {
        0 ..< self
    }
}
