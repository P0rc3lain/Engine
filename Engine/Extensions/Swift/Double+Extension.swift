//
//  Copyright © 2021 Mateusz Stompór. All rights reserved.
//

extension Double {
    func clamp(min lowerBound: Double, max highBound: Double) -> Double {
        max(min(self, highBound), lowerBound)
    }
}
