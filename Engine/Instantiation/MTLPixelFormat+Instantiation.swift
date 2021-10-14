//
//  MTLPixelFormat+Instantiation.swift
//  Engine
//
//  Created by Mateusz Stompór on 15/11/2020.
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
    static var lightenSceneDepthStencil: MTLPixelFormat {
        .depth32Float_stencil8
    }
    static var environmentRendererColor: MTLPixelFormat {
        lightenSceneColor
    }
    static var environmentRendererDepthStencil: MTLPixelFormat {
        lightenSceneDepthStencil
    }
}
