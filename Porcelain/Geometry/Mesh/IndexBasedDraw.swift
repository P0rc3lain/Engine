//
//  IndexBasedDraw.swift
//  Porcelain
//
//  Created by Mateusz Stompór on 10/11/2020.
//

import Metal

struct IndexBasedDraw {
    let indexBuffer: DataBuffer
    let indexCount: Int
    let indexType: MTLIndexType
    let primitiveType: MTLPrimitiveType
}
