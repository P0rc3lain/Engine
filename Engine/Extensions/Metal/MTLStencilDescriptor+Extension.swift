//
//  Copyright © 2021 Mateusz Stompór. All rights reserved.
//

import Metal

extension MTLStencilDescriptor {
    static var environmentRenderer: MTLStencilDescriptor {
        let stencil = MTLStencilDescriptor()
        stencil.stencilCompareFunction = .equal
        stencil.stencilFailureOperation = .keep
        stencil.depthFailureOperation = .keep
        stencil.depthStencilPassOperation = .keep
        return stencil
    }
    static var fogJob: MTLStencilDescriptor {
        let stencil = MTLStencilDescriptor()
        stencil.stencilCompareFunction = .equal
        stencil.readMask = 0x1
        stencil.writeMask = 0x1
        stencil.stencilFailureOperation = .keep
        stencil.depthFailureOperation = .keep
        stencil.depthStencilPassOperation = .replace
        return stencil
    }
    static var lightRenderer: MTLStencilDescriptor {
        let stencil = MTLStencilDescriptor()
        stencil.stencilCompareFunction = .greaterEqual
        stencil.readMask = 0b00000000
        stencil.writeMask = 0xFF
        stencil.stencilFailureOperation = .keep
        stencil.depthFailureOperation = .keep
        stencil.depthStencilPassOperation = .replace
        return stencil
    }
    static var spotRenderer: MTLStencilDescriptor {
        lightRenderer
    }
    static var ambientRenderer: MTLStencilDescriptor {
        lightRenderer
    }
    static var directionalRenderer: MTLStencilDescriptor {
        lightRenderer
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
