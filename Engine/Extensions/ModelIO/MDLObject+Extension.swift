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
        for index in 0 ..< children.objects.count {
            children[index].walk(handler: handler)
        }
    }
    func walk<T>(handler: (MDLObject, T?) -> T?) {
        walk(handler: handler, initialValue: nil)
    }
    func walk<T>(handler: (MDLObject, T?) -> T?, initialValue: T?) {
        let value = handler(self, initialValue)
        for index in 0 ..< children.objects.count {
            children[index].walk(handler: handler, initialValue: value)
        }
    }
}
