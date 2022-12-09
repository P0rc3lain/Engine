//
//  Copyright © 2021 Mateusz Stompór. All rights reserved.
//

import CoreGraphics

extension CGSize {
    var aspectRatio: Float {
        Float(width / height)
    }
    init(side: CGFloat) {
        self.init(width: side, height: side)
    }
}
