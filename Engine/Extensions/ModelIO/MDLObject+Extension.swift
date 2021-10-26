//
//  Copyright © 2021 Mateusz Stompór. All rights reserved.
//

import ModelIO

extension MDLObject {
    var path: String {
        guard let parent = parent else {
            return name
        }
        return parent.path + "/" + name
    }
    func walk(handler: (MDLObject) -> Void) {
        handler(self)
        for i in 0 ..< children.count {
            children[i].walk(handler: handler)
        }
    }
}
