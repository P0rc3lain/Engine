//
//  Copyright © 2021 Mateusz Stompór. All rights reserved.
//

import simd

extension AnimatedFloat3 {
    static public var defaultScale: AnimatedFloat3 {
        .static(from: .one)
    }
    static public var defaultTranslation: AnimatedFloat3 {
        .static(from: .zero)
    }
}
