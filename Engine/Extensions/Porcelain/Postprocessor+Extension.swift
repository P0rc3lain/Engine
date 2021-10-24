//
//  Copyright © 2021 Mateusz Stompór. All rights reserved.
//

import Metal

extension Postprocessor {
    static func make(device: MTLDevice, inputTexture: MTLTexture, outputFormat: MTLPixelFormat, canvasSize: CGSize) -> Postprocessor {
        let library = device.makePorcelainLibrary()
        let pipelineState = device.makeRenderPipelineStatePostprocessor(library: library, format: outputFormat)
        let plane = GPUGeometry.screenSpacePlane(device: device)
        return Postprocessor(pipelineState: pipelineState, texture: inputTexture, plane: plane, canvasSize: canvasSize)
    }
}
