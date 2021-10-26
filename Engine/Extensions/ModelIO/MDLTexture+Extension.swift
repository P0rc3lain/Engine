//
//  Copyright © 2021 Mateusz Stompór. All rights reserved.
//

import simd
import Metal
import ModelIO
import MetalKit

extension MDLTexture {
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
    func upload(device: MTLDevice) -> MTLTexture? {
        let loader = MTKTextureLoader(device: device)
        let texture = try? loader.newTexture(texture: self, options: nil)
        texture?.label = name
        return texture
    }
}
