//
//  EnvironmentRenderer+Instantiation.swift
//  Engine
//
//  Created by Mateusz Stompór on 14/11/2020.
//

import Metal

extension EnvironmentRenderer {
    static func make(device: MTLDevice, drawableSize: CGSize) -> EnvironmentRenderer  {
        let library = device.makePorcelainLibrary()
        let environmentPipelineState = device.makeRenderPipelineStateEnvironmentRenderer(library: library)
        let depthStencilState = device.makeDepthStencilStateEnvironmentRenderer()
        let cube = Geometry2.cube(device: device)
        return EnvironmentRenderer(pipelineState: environmentPipelineState,
                                   depthStentilState: depthStencilState,
                                   drawableSize: drawableSize, cube: cube)
    }
}
