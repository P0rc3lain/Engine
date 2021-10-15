//
//  MDLAsset.swift
//  Binarizer
//
//  Created by Mateusz Stompór on 11/10/2021.
//

import ModelIO

extension MDLAsset {
    func walk(handler: (MDLObject) -> Void) {
        for i in 0 ..< count {
            self[i]?.walk(handler: handler)
        }
    }
}
