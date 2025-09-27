//
//  Copyright © 2021 Mateusz Stompór. All rights reserved.
//

import CoreGraphics
import Metal
import PNShared

struct PNPipeline: PNStage {
    var io: PNGPUIO
    private var combineStage: PNCombineStage
    private var ssaoStage: PNSSAOStage
    private var postprocessStage: PNPostprocessStage
    private var gBufferStage: PNGBufferStage
    private var shadowStage: PNShadowStage
    init?(device: MTLDevice,
          renderingSize: CGSize) {
        guard let gBufferStage = PNGBufferStage(device: device,
                                                renderingSize: renderingSize),
              let shadowStage = PNShadowStage(device: device,
                                              shadowTextureSize: PNDefaults.shared.rendering.shadowSize),
              let ssaoStage = PNSSAOStage(device: device,
                                          renderingSize: renderingSize,
                                          prTexture: gBufferStage.io.output.color[2],
                                          nmTexture: gBufferStage.io.output.color[1],
                                          blurSigma: PNDefaults.shared.shaders.ssao.blurSigma),
              let combineStage = PNCombineStage(device: device,
                                                renderingSize: renderingSize,
                                                gBufferOutput: gBufferStage.io.output,
                                                ssaoTexture: ssaoStage.io.output.color[0],
                                                spotLightShadows: shadowStage.io.output.depth[0],
                                                pointLightsShadows: shadowStage.io.output.depth[1],
                                                directionalLightsShadows: shadowStage.io.output.depth[2]),
              let postprocessStage = PNPostprocessStage(input: combineStage.io.output.color[0],
                                                        velocities: gBufferStage.io.output.color[3],
                                                        bloomBlurSigma: PNDefaults.shared.shaders.postprocess.bloom.blurSigma,
                                                        device: device,
                                                        renderingSize: renderingSize) else {
            return nil
        }
        self.gBufferStage = gBufferStage
        self.combineStage = combineStage
        self.postprocessStage = postprocessStage
        self.ssaoStage = ssaoStage
        self.shadowStage = shadowStage
        self.io = PNGPUIO(input: .empty,
                          output: PNGPUSupply(color: postprocessStage.io.output.color))
    }
    func draw(commandQueue: MTLCommandQueue, supply: PNFrameSupply) {
        shadowStage.draw(commandQueue: commandQueue,
                         supply: supply)
        gBufferStage.draw(commandQueue: commandQueue,
                          supply: supply)
        if !supply.scene.ambientLights.isEmpty {
            ssaoStage.draw(commandQueue: commandQueue,
                           supply: supply)
        }
        combineStage.draw(commandQueue: commandQueue,
                          supply: supply)
        postprocessStage.draw(commandQueue: commandQueue,
                              supply: supply)
    }
}
