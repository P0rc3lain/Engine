//
//  Copyright © 2021 Mateusz Stompór. All rights reserved.
//

import MetalBinding

extension SSAOUniforms {
    static var `default`: SSAOUniforms {
        SSAOUniforms(sampleCount: 8,
                     noiseCount: 64,
                     radius: 0.2,
                     bias: 0.025,
                     power: 16)
    }
}
