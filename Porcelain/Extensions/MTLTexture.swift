//
//  MTLTexture.swift
//  Porcelain
//
//  Created by Mateusz Stompór on 10/11/2020.
//

import simd
import Metal

extension MTLDevice {
    func makeSolidTexture(device: MTLDevice,
                          color: simd_float4,
                          pixelFormat: MTLPixelFormat = .bgra8Unorm) -> MTLTexture? {
        device.makeTexture(descriptor: MTLTextureDescriptor.solid(color: color, pixelFormat: pixelFormat))
    }
}
