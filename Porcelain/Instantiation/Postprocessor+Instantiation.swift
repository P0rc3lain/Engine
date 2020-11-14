//
//  Postprocessor+Instantiation.swift
//  Porcelain
//
//  Created by Mateusz Stompór on 14/11/2020.
//

import Metal

extension Postprocessor {
    static func make(device: MTLDevice, inputTexture: MTLTexture, outputFormat: MTLPixelFormat, canvasSize: CGSize) -> Postprocessor {
        let library = device.makePorcelainLibrary()
        let pipelineState = device.makeRenderPipelineStatePostprocessor(library: library, format: outputFormat)
        let plane = Geometry.screenSpacePlane(device: device)
        return Postprocessor(pipelineState: pipelineState, texture: inputTexture, plane: plane, canvasSize: canvasSize)
    }
}
