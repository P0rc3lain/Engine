//
//  Copyright © 2021 Mateusz Stompór. All rights reserved.
//

import Metal
import ModelIO

public struct PNIMaterial: PNMaterial {
    public var argumentBuffer: MTLBuffer
    
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
        
        let device = albedo.device
        
        let bufferCreator = MaterialArgumentBuffer(device: device,
                                                   albedo: albedo,
                                                   roughness: roughness,
                                                   normals: normals,
                                                   metallic: metallic)
        
        self.argumentBuffer = bufferCreator.create()
    }
    public init?(device: MTLDevice,
                 albedo: simd_float4,
                 metallic metallicValue: Float,
                 roughness roughnessValue: Float,
                 name: String = "") {
        assertZeroOne(roughnessValue)
        assertZeroOne(metallicValue)
        let normals = MDLTexture.solid2D(color: .defaultNormalsColor, name: "Normals")
        let albedo = MDLTexture.solid2D(color: albedo, name: "Albedo")
        let metallic = MDLTexture.solid2D(color: simd_float4(simd_float3(repeating: metallicValue), 1),
                                          name: "Metallic")
        let roughness = MDLTexture.solid2D(color: simd_float4(simd_float3(repeating: roughnessValue), 1),
                                           name: "Roughness")
        guard let uploadedNormals = normals.upload(device: device),
              let uploadedMetallic = metallic.upload(device: device),
              let uploadedRoughness = roughness.upload(device: device),
              let uploadedAlbedo = albedo.upload(device: device) else {
            return nil
        }
        self.init(name: name,
                  albedo: uploadedAlbedo,
                  roughness: uploadedRoughness,
                  normals: uploadedNormals,
                  metallic: uploadedMetallic)
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
        guard let uploadedNormals = normals.upload(device: device),
              let uploadedMetallic = metallic.upload(device: device),
              let uploadedRoughness = roughness.upload(device: device),
              let uploadedAlbedo = albedo.upload(device: device) else {
            return nil
        }
        return PNIMaterial(name: "Default",
                           albedo: uploadedAlbedo,
                           roughness: uploadedRoughness,
                           normals: uploadedNormals,
                           metallic: uploadedMetallic)
    }
}
