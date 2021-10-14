//
//  DataBuffer.swift
//  Engine
//
//  Created by Mateusz Stompór on 10/11/2020.
//

import Metal

class DataBuffer {
    // MARK: - Properties
    let buffer: MTLBuffer
    let length: Int
    let offset: Int
    // MARK: - Initialization
    init(buffer: MTLBuffer, length: Int, offset: Int) {
        self.buffer = buffer
        self.length = length
        self.offset = offset
    }
}
