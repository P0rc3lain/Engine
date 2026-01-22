//
//  Copyright © 2021 Mateusz Stompór. All rights reserved.
//

import MetalKit
import ModelIO
import simd

extension MDLTexture {
    var canBeMipMapped: Bool {
        dimensions.x >= 2 && dimensions.y >= 2
    }
    static func solid2D(color: simd_float4, name: String) -> MDLTexture {
        MDLTexture(data: Data.solid2DTexture(color: color),
                   topLeftOrigin: true,
                   name: name,
                   dimensions: simd_int2(8, 8),
                   rowStride: 8,
                   channelCount: 4,
                   channelEncoding: .uInt8,
                   isCube: false)
    }
    func upload(device: MTLDevice,
                usage: MTLTextureUsage = .shaderRead,
                storageMode: MTLStorageMode = .shared,
                generateMipMaps: Bool = true) -> MTLTexture? {
        let loader = MTKTextureLoader(device: device)
        let options: [MTKTextureLoader.Option: Any] = [
            .generateMipmaps: canBeMipMapped && generateMipMaps,
            .textureUsage: NSNumber(value: usage.rawValue),
            .textureStorageMode: NSNumber(value: storageMode.rawValue)
        ]

        guard let texture = try? loader.newTexture(texture: self, options: options) else {
            return nil
        }
        texture.label = name
        return texture
    }
}
