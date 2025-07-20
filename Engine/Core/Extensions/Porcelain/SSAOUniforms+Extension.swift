//
//  Copyright © 2021 Mateusz Stompór. All rights reserved.
//

import PNShared

extension SSAOUniforms {
    static var `default`: SSAOUniforms {
        SSAOUniforms(radius: 0.2,
                     bias: 0.025,
                     power: 16)
    }
}
