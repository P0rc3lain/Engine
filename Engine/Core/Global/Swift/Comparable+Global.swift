//
//  Copyright © 2022 Mateusz Stompór. All rights reserved.
//

func clamp<N: Comparable>(value: N, min lowerBound: N, max highBound: N) -> N {
    max(min(value, highBound), lowerBound)
}
