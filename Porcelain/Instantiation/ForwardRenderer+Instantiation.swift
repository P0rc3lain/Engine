//
//  ForwardRenderer+Instantiation.swift
//  Porcelain
//
//  Created by Mateusz Stompór on 14/11/2020.
//

import Metal

extension ForwardRenderer {
    static func make(device: MTLDevice, drawableSize: CGSize) -> ForwardRenderer {
        let library = device.makePorcelainLibrary()
        let pipelineState = device.makeRenderPipelineStateForwardRenderer(library: library)
        let depthStencilState = device.makeDepthStencilStateForwardRenderer()
        return ForwardRenderer(pipelineState: pipelineState, depthStencilState: depthStencilState, drawableSize: drawableSize)
    }
}
