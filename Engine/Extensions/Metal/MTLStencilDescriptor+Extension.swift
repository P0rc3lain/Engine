//
//  Copyright © 2021 Mateusz Stompór. All rights reserved.
//

import Metal

extension MTLStencilDescriptor {
    static var environment: MTLStencilDescriptor {
        let stencil = MTLStencilDescriptor()
        stencil.stencilCompareFunction = .equal
        stencil.stencilFailureOperation = .keep
        stencil.depthFailureOperation = .keep
        stencil.depthStencilPassOperation = .keep
        return stencil
    }
    static var fog: MTLStencilDescriptor {
        let stencil = MTLStencilDescriptor()
        stencil.stencilCompareFunction = .equal
        stencil.readMask = 0x1
        stencil.writeMask = 0x1
        stencil.stencilFailureOperation = .keep
        stencil.depthFailureOperation = .keep
        stencil.depthStencilPassOperation = .replace
        return stencil
    }
    static var lighten: MTLStencilDescriptor {
        let stencil = MTLStencilDescriptor()
        stencil.stencilCompareFunction = .greaterEqual
        stencil.readMask = 0b00000000
        stencil.writeMask = 0xFF
        stencil.stencilFailureOperation = .keep
        stencil.depthFailureOperation = .keep
        stencil.depthStencilPassOperation = .replace
        return stencil
    }
    static var spot: MTLStencilDescriptor {
        lighten
    }
    static var ambient: MTLStencilDescriptor {
        lighten
    }
    static var directional: MTLStencilDescriptor {
        lighten
    }
    static var gBuffer: MTLStencilDescriptor {
        let stencil = MTLStencilDescriptor()
        stencil.stencilCompareFunction = .greaterEqual
        stencil.readMask = 0b00000000
        stencil.writeMask = 0xFF
        stencil.stencilFailureOperation = .keep
        stencil.depthFailureOperation = .keep
        stencil.depthStencilPassOperation = .replace
        return stencil
    }
    static var translucent: MTLStencilDescriptor {
        let stencil = MTLStencilDescriptor()
        stencil.stencilCompareFunction = .greaterEqual
        stencil.readMask = 0b00000000
        stencil.writeMask = 0xFF
        stencil.stencilFailureOperation = .keep
        stencil.depthFailureOperation = .keep
        stencil.depthStencilPassOperation = .replace
        return stencil
    }
}
