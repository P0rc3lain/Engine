//
//  Extension+Texture.swift
//  Uploader
//
//  Created by Mateusz Stompór on 15/10/2021.
//

import Metal

extension Texture {
    func upload(device: MTLDevice) -> MTLTexture? {
        let descriptor = MTLTextureDescriptor()
        descriptor.textureType = .type2D
        descriptor.width = Int(dimensions.x)
        descriptor.height = Int(dimensions.y)
        descriptor.storageMode = .shared
        descriptor.pixelFormat = .rg16Float
        descriptor.usage = .renderTarget
        guard let texture = device.makeTexture(descriptor: descriptor) else {
            return nil
        }
        let origin = MTLOrigin(x: 0, y: 0, z: 0)
        let size = MTLSize(width: Int(dimensions.x), height: Int(dimensions.y),
                           depth: channelCount)
        let region = MTLRegion(origin: origin, size: size)
        data.withUnsafeBytes { ptr in
            texture.replace(region: region, mipmapLevel: 0, withBytes: ptr.baseAddress!, bytesPerRow: 32)
        }
        return texture
    }
}
