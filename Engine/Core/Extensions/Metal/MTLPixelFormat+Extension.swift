//
//  Copyright © 2021 Mateusz Stompór. All rights reserved.
//

import Metal

extension MTLPixelFormat {
    static var gBufferARC: MTLPixelFormat {
        .rgba16Float
    }
    static var gBufferNMC: MTLPixelFormat {
        .rgba32Float
    }
    static var gBufferPRC: MTLPixelFormat {
        .rgba32Float
    }
    static var gBufferVelocity: MTLPixelFormat {
        .rg16Float
    }
    static var translucentC: MTLPixelFormat {
        .rgba16Float
    }
    static var translucentDS: MTLPixelFormat {
        .depth32Float_stencil8
    }
    static var particleC: MTLPixelFormat {
        .rgba16Float
    }
    static var particleDS: MTLPixelFormat {
        .depth32Float_stencil8
    }
    static var gBufferDS: MTLPixelFormat {
        .depth32Float_stencil8
    }
    static var spotShadowDS: MTLPixelFormat {
        .depth32Float
    }
    static var directionalShadowDS: MTLPixelFormat {
        .depth32Float
    }
    static var omniShadowDS: MTLPixelFormat {
        .depth32Float
    }
    static var ambientC: MTLPixelFormat {
        .rgba16Float
    }
    static var directionalC: MTLPixelFormat {
        .rgba16Float
    }
    static var spotC: MTLPixelFormat {
        .rgba16Float
    }
    static var lightenSceneC: MTLPixelFormat {
        .rgba16Float
    }
    static var ssaoC: MTLPixelFormat {
        .r16Float
    }
    static var lightenSceneDS: MTLPixelFormat {
        .depth32Float_stencil8
    }
    static var directionalDS: MTLPixelFormat {
        .depth32Float_stencil8
    }
    static var ambientDS: MTLPixelFormat {
        .depth32Float_stencil8
    }
    static var spotDS: MTLPixelFormat {
        .depth32Float_stencil8
    }
    static var bloomSplitC: MTLPixelFormat {
        .rgba16Float
    }
    static var postprocessOutput: MTLPixelFormat {
        .rgba16Float
    }
    static var postprocessInputC: MTLPixelFormat {
        .rgba16Float
    }
    static var environmentC: MTLPixelFormat {
        lightenSceneC
    }
    static var fogC: MTLPixelFormat {
        lightenSceneC
    }
    static var environmentDS: MTLPixelFormat {
        lightenSceneDS
    }
    static var fogDS: MTLPixelFormat {
        lightenSceneDS
    }
    static var postprocessorC: MTLPixelFormat {
        .rgba16Float
    }
}
