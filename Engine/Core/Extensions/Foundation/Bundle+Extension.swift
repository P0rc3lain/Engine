//
//  Copyright © 2022 Mateusz Stompór. All rights reserved.
//

import Foundation

extension Bundle {
    /// An empty class used solely to anchor the bundle lookup to the current module.
    fileprivate class Unnamed { }
    /// Returns the bundle associated with the current module, using the Unnamed marker class.
    static var current: Bundle {
        Bundle(for: Unnamed.self)
    }
    /// Retrieves the bundle identifier, terminating with a descriptive error if unavailable.
    var bundleIdentifierSafe: String {
        guard let bundleIdentifier = bundleIdentifier else {
            fatalError("Could not retrieve bundle identifier")
        }
        return bundleIdentifier
    }
}
