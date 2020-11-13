//
//  MTLVertexBufferLayoutDescriptor+Instantiation.swift
//  Porcelain
//
//  Created by Mateusz Stompór on 14/11/2020.
//

import Metal

extension MTLVertexBufferLayoutDescriptor {
    static var environmentRenderer: MTLVertexBufferLayoutDescriptor {
        let layout = MTLVertexBufferLayoutDescriptor()
        layout.stepFunction = .perVertex
        layout.stride = MemoryLayout<SIMD4<Float>>.stride
        layout.stepRate = 1
        return layout
    }
}
