//
//  Copyright © 2021 Mateusz Stompór. All rights reserved.
//

import MetalBinding

extension SSAOUniforms {
    static var `default`: SSAOUniforms {
        SSAOUniforms(sampleCount: 32,
                     noiseCount: 16,
                     radius: 0.7,
                     bias: 0.05,
                     power: 2)
    }
}
