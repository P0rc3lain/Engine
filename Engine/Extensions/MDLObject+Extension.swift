//
//  MDLObject.swift
//  Binarizer
//
//  Created by Mateusz Stompór on 11/10/2021.
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
