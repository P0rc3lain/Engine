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
    static var lightenSceneColor: MTLPixelFormat {
        .rgba16Float
    }
    static var ssaoColor: MTLPixelFormat {
        .r16Float
    }
    static var lightenSceneDepthStencil: MTLPixelFormat {
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
}
