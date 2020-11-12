//
//  MTLTexture.swift
//  Porcelain
//
//  Created by Mateusz Stompór on 10/11/2020.
//

import simd
import Metal

extension MTLDevice {
    func makeSolid2DTexture(color: simd_float4,
                            pixelFormat: MTLPixelFormat = .bgra8Unorm) -> MTLTexture? {
        assert(length(color) <= 2.001, "Color values must be in [0.0, 1.0] range")
        let descriptor = MTLTextureDescriptor.minimalSolidColor2D(pixelFormat: pixelFormat)
        guard let texture = self.makeTexture(descriptor: descriptor) else {
            return nil
        }
        let origin = MTLOrigin(x: 0, y: 0, z: 0)
        let size = MTLSize(width: texture.width, height: texture.height, depth: texture.depth)
        let region = MTLRegion(origin: origin, size: size)
        let mapped = simd_uchar4(color * 255)
        Array<simd_uchar4>(repeating: mapped, count: 64).withUnsafeBytes { ptr in
            texture.replace(region: region, mipmapLevel: 0, withBytes: ptr.baseAddress!, bytesPerRow: 32)
        }
        return texture
    }
}
