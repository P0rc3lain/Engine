//
//  Copyright © 2021 Mateusz Stompór. All rights reserved.
//

import Foundation

extension CGSize {
    var aspectRatio: Float {
        Float(width / height)
    }
    init(side: CGFloat) {
        self.init(width: side, height: side)
    }
}
