//
//  Copyright © 2021 Mateusz Stompór. All rights reserved.
//

import Metal

public struct PNIMaterial: PNMaterial {
    public let name: String
    public let albedo: MTLTexture
    public let roughness: MTLTexture
    public let normals: MTLTexture
    public let metallic: MTLTexture
    public init(name: String,
                albedo: MTLTexture,
                roughness: MTLTexture,
                normals: MTLTexture,
                metallic: MTLTexture) {
        self.name = name
        self.albedo = albedo
        self.roughness = roughness
        self.normals = normals
        self.metallic = metallic
    }
}
