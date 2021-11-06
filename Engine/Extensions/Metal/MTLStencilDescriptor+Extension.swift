//
//  Copyright © 2021 Mateusz Stompór. All rights reserved.
//

import Metal

extension MTLStencilDescriptor {
    static var environmentRenderer: MTLStencilDescriptor {
        let stencil = MTLStencilDescriptor()
        stencil.stencilCompareFunction = .equal
        stencil.stencilFailureOperation = .replace
        stencil.depthFailureOperation = .keep
        stencil.depthStencilPassOperation = .invert
        return stencil
    }
    static var omniRenderer: MTLStencilDescriptor {
        let stencil = MTLStencilDescriptor()
        stencil.stencilCompareFunction = .greaterEqual
        stencil.readMask = 0b00000000
        stencil.writeMask = 0xFF
        stencil.stencilFailureOperation = .keep
        stencil.depthFailureOperation = .keep
        stencil.depthStencilPassOperation = .replace
        return stencil
    }
    static var ambientRenderer: MTLStencilDescriptor {
        omniRenderer
    }
    static var directionalRenderer: MTLStencilDescriptor {
        omniRenderer
    }
    static var gBufferRenderer: MTLStencilDescriptor {
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
