//
//  Copyright © 2021 Mateusz Stompór. All rights reserved.
//

import Metal

extension MTLPixelFormat {
    static var gBufferAR: MTLPixelFormat {
        .rgba16Float
    }
    static var gBufferNM: MTLPixelFormat {
        .rgba16Float
    }
    static var gBufferPR: MTLPixelFormat {
        .rgba16Float
    }
    static var gBufferDepthStencil: MTLPixelFormat {
        .depth32Float_stencil8
    }
    static var spotShadowDepthStencil: MTLPixelFormat {
        .depth32Float
    }
    static var omniShadowDepthStencil: MTLPixelFormat {
        .depth32Float
    }
    static var ambientColor: MTLPixelFormat {
        .rgba16Float
    }
    static var directionalColor: MTLPixelFormat {
        .rgba16Float
    }
    static var spotColor: MTLPixelFormat {
        .rgba16Float
    }
    static var lightenSceneColor: MTLPixelFormat {
        .rgba16Float
    }
    static var ssaoColor: MTLPixelFormat {
        .r16Float
    }
    static var lightenSceneDepthStencil: MTLPixelFormat {
        .depth32Float_stencil8
    }
    static var directionalDepthStencil: MTLPixelFormat {
        .depth32Float_stencil8
    }
    static var ambientDepthStencil: MTLPixelFormat {
        .depth32Float_stencil8
    }
    static var spotDepthStencil: MTLPixelFormat {
        .depth32Float_stencil8
    }
    static var bloomSplitColor: MTLPixelFormat {
        .rgba16Float
    }
    static var bloomMergeColor: MTLPixelFormat {
        .rgba16Float
    }
    static var environmentRendererColor: MTLPixelFormat {
        lightenSceneColor
    }
    static var environmentRendererDepthStencil: MTLPixelFormat {
        lightenSceneDepthStencil
    }
    static var postprocessorRendererColor: MTLPixelFormat {
        .rgba16Float
    }
    static var vignetteColor: MTLPixelFormat {
        .postprocessorRendererColor
    }
}
