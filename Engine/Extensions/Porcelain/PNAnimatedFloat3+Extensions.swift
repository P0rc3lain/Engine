//
//  Copyright © 2021 Mateusz Stompór. All rights reserved.
//

import simd

extension PNAnimatedFloat3 {
    static public var defaultScale: PNAnimatedFloat3 {
        .static(from: .one)
    }
    static public var defaultTranslation: PNAnimatedFloat3 {
        .static(from: .zero)
    }
}
