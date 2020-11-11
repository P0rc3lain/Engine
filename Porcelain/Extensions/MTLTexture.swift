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
        let descriptor = MTLTextureDescriptor.singlePixel2D(pixelFormat: pixelFormat)
        guard let texture = device.makeTexture(descriptor: descriptor) else {
            return nil
        }
        let origin = MTLOrigin(x: 0, y: 0, z: 0)
        let size = MTLSize(width: texture.width, height: texture.height, depth: texture.depth)
        let region = MTLRegion(origin: origin, size: size)
        withUnsafePointer(to: color) { ptr in
            texture.replace(region: region, mipmapLevel: 0, withBytes: ptr, bytesPerRow:  4 * MemoryLayout<UInt8>.size)
        }
        return texture
    }
}
