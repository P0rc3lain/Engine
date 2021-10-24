//
//  MTLRenderCommandEncoder+Extension.swift
//  Engine
//
//  Created by Mateusz Stompór on 24/10/2021.
//

import Metal

extension MTLRenderCommandEncoder {
    func setVertexBuffer(_ buffer: MTLBuffer?, index: Int) {
        setVertexBuffer(buffer, offset: 0, index: index)
    }
    func setFragmentBuffer(_ buffer: MTLBuffer?, index: Int) {
        setFragmentBuffer(buffer, offset: 0, index: index)
    }
}
