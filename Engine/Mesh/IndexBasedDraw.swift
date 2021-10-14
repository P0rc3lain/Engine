//
//  IndexBasedDraw.swift
//  Engine
//
//  Created by Mateusz Stompór on 10/11/2020.
//

import Metal

class IndexBasedDraw {
    // MARK: - Properties
    let indexBuffer: DataBuffer
    let indexCount: Int
    let indexType: MTLIndexType
    let primitiveType: MTLPrimitiveType
    // MARK: - Initialization
    init(indexBuffer: DataBuffer,
         indexCount: Int,
         indexType: MTLIndexType,
         primitiveType: MTLPrimitiveType) {
        self.indexBuffer = indexBuffer
        self.indexCount = indexCount
        self.indexType = indexType
        self.primitiveType = primitiveType
    }
}
