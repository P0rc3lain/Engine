//
//  Copyright © 2022 Mateusz Stompór. All rights reserved.
//

import Metal

/// Contains configuration of culling techinques.
/// Used to optimize mesh surfaces rendering.
public struct PNCulling {
    public let frontCulling: MTLCullMode
    public let backCulling: MTLCullMode
    public let winding: MTLWinding
    public init(frontCulling: MTLCullMode,
                backCulling: MTLCullMode,
                winding: MTLWinding) {
        self.frontCulling = frontCulling
        self.backCulling = backCulling
        self.winding = winding
    }
    public static func `none`(winding: MTLWinding) -> PNCulling {
        PNCulling(frontCulling: .none,
                  backCulling: .none,
                  winding: winding)
    }
}
