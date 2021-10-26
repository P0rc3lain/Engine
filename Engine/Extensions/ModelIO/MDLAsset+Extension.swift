//
//  Copyright © 2021 Mateusz Stompór. All rights reserved.
//

import ModelIO

extension MDLAsset {
    func walk(handler: (MDLObject) -> Void) {
        for i in 0 ..< count {
            self[i]?.walk(handler: handler)
        }
    }
}
