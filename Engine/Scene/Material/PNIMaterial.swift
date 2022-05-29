//
//  Copyright © 2021 Mateusz Stompór. All rights reserved.
//

import Metal
import ModelIO

public struct PNIMaterial: PNMaterial {
    public var name: String
    public var albedo: MTLTexture
    public var roughness: MTLTexture
    public var normals: MTLTexture
    public var metallic: MTLTexture
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
    public static func `default`(device: MTLDevice) -> PNIMaterial? {
        let normals = MDLTexture.solid2D(color: .defaultNormalsColor,
                                         name: "Default Normals")
        let metallic = MDLTexture.solid2D(color: .defaultMetallicColor,
                                          name: "Default Metallic")
        let roughness = MDLTexture.solid2D(color: .defaultRoughnessColor,
                                           name: "Default Roughness")
        let albedo = MDLTexture.solid2D(color: .defaultBaseColor,
                                        name: "Default Albedo")
        guard let uN = normals.upload(device: device),
              let uM = metallic.upload(device: device),
              let uR = roughness.upload(device: device),
              let uA = albedo.upload(device: device) else {
            return nil
        }
        return PNIMaterial(name: "Default",
                           albedo: uA,
                           roughness: uR,
                           normals: uN,
                           metallic: uM)
    }
}
