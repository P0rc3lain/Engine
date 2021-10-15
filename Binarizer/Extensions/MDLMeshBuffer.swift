//
//  MDLMeshBuffer.swift
//  Binarizer
//
//  Created by Mateusz Stompór on 12/10/2021.
//

import ModelIO

extension MDLMeshBuffer {
    var rawData: Data {
        return Data(bytes: map().bytes, count: length)
    }
}
