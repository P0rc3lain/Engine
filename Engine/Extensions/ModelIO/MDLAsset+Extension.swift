//
//  Copyright © 2021 Mateusz Stompór. All rights reserved.
//

import ModelIO

extension MDLAsset {
    var indices: Range<Int> {
        0 ..< count
    }
    func walk(handler: (MDLObject) -> Void) {
        for index in indices {
            self[index]?.walk(handler: handler)
        }
    }
}
