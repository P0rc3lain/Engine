//
//  Copyright © 2021 Mateusz Stompór. All rights reserved.
//

import Metal

extension MTLBuffer {
    var offset: Int {
        if #available(macOS 10.15, *) {
            return heapOffset
        } else {
            return 0
        }
    }
}
