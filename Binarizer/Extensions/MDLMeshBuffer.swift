//
//  MDLMeshBuffer.swift
//  Binarizer
//
//  Created by Mateusz Stompór on 12/10/2021.
//

import ModelIO

extension MDLMeshBuffer {
    var rawData: Data {
        let data = Data(count: length)
        fill(data, offset: 0)
        return data
    }
}
