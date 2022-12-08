//
//  Copyright © 2022 Mateusz Stompór. All rights reserved.
//

import Metal

extension MTLSize {
    init(width: Int, height: Int) {
        self.init(width: width, height: height, depth: 1)
    }
}
