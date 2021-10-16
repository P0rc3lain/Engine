//
//  MDLSubmesh.swift
//  Engine
//
//  Created by Mateusz Stompór on 12/10/2021.
//

import ModelIO

extension MDLSubmesh {
    var porcelainIndexBasedDraw: RamIndexBasedDraw {
        let rawBuffer = indexBuffer.rawData
        let dataBuffer = DataBuffer(buffer: rawBuffer, length: rawBuffer.count, offset: 0)
        return IndexBasedDraw(indexBuffer: dataBuffer,
                              indexCount: indexCount,
                              indexType: IndexBitDepth(modelIO: indexType),
                              primitiveType: PrimitiveType(modelIO: geometryType))
        
    }
}
