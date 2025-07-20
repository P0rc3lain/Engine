//
//  Copyright © 2021 Mateusz Stompór. All rights reserved.
//

extension Float {
    public var radians: Float {
        self / 180 * .pi
    }
    public var half: Float16 {
        Float16(self)
    }
}
