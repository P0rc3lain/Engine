//
//  Copyright © 2022 Mateusz Stompór. All rights reserved.
//

import Foundation

extension NSRegularExpression {
    public func matches(in string: String,
                        options: NSRegularExpression.MatchingOptions = []) -> [NSTextCheckingResult] {
        matches(in: string, options: options, range: string.whole)
    }
    public func firstMatch(in string: String,
                           options: NSRegularExpression.MatchingOptions = []) -> NSTextCheckingResult? {
        firstMatch(in: string, options: options, range: string.whole)
    }
}
