//
//  Copyright © 2022 Mateusz Stompór. All rights reserved.
//

import Foundation

extension Bundle {
    fileprivate class Unnamed { }
    static var current: Bundle {
        Bundle(for: Unnamed.self)
    }
}
