//
//  Copyright © 2022 Mateusz Stompór. All rights reserved.
//

import Foundation

extension Bundle {
    fileprivate class Unnamed { }
    static var current: Bundle {
        Bundle(for: Unnamed.self)
    }
    var identifier: String {
        guard let bundleIdentifier = bundleIdentifier else {
            fatalError("Could not retrieve bundle identifier")
        }
        return bundleIdentifier
    }
}
