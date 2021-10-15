//
//  Texture+Extension.swift
//  Engine
//
//  Created by Mateusz Stompór on 15/10/2021.
//

import simd
import MetalKit

extension Texture {
    static func solid2D(color: simd_float4) -> Texture {
        return Texture(data: Data.solid2DTexture(color: color),
                       dimensions: simd_int2(8, 8),
                       rowStride: 8,
                       channelCount: 3,
                       channelEncoding: .float32,
                       isCube: false,
                       mipLevelCount: 0)
    }
    func upload(device: MTLDevice) -> MTLTexture? {
        let loader = MTKTextureLoader.init(device: device)
        return try! loader.newTexture(texture: self.texture, options: nil)
        
        
        let descriptor = MTLTextureDescriptor()
        descriptor.textureType = .type2D
        descriptor.width = Int(dimensions.x)
        descriptor.height = Int(dimensions.y)
        descriptor.storageMode = .managed
        descriptor.pixelFormat = .rgba16Float
        descriptor.usage = .shaderRead
        guard let texture = device.makeTexture(descriptor: descriptor) else {
            return nil
        }
        let origin = MTLOrigin(x: 0, y: 0, z: 0)
        let size = MTLSize(width: Int(dimensions.x), height: Int(dimensions.y),
                           depth: 1)
        let region = MTLRegion(origin: origin, size: size)
        data.withUnsafeBytes { ptr in
            texture.replace(region: region,
                            mipmapLevel: mipLevelCount,
                            withBytes: ptr.baseAddress!,
                            bytesPerRow: rowStride)
        }
        return texture
    }
}
