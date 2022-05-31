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
    public var isTranslucent: Bool = false
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
    public init?(device: MTLDevice,
                 albedo: simd_float4,
                 metallic metallicValue: Float,
                 roughness roughnessValue: Float,
                 name: String = "") {
        assert(metallicValue >= 0 && metallicValue <= 1, "Metallic must be in range [0, 1]")
        assert(roughnessValue >= 0 && roughnessValue <= 1, "Roughness must be in range [0, 1]")
        let normals = MDLTexture.solid2D(color: .defaultNormalsColor, name: "Normals")
        let albedo = MDLTexture.solid2D(color: albedo, name: "Albedo")
        let metallic = MDLTexture.solid2D(color: simd_float4(simd_float3(repeating: metallicValue), 1),
                                          name: "Metallic")
        let roughness = MDLTexture.solid2D(color: simd_float4(simd_float3(repeating: roughnessValue), 1),
                                           name: "Roughness")
        guard let uN = normals.upload(device: device),
              let uM = metallic.upload(device: device),
              let uR = roughness.upload(device: device),
              let uA = albedo.upload(device: device) else {
            return nil
        }
        self.roughness = uR
        self.albedo = uA
        self.normals = uN
        self.metallic = uM
        self.name = name
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
