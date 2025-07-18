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
        
        let albedoTexture = MTLArgumentDescriptor()
        albedoTexture.dataType = .texture
        albedoTexture.index = 0
        albedoTexture.access = .readOnly
        albedoTexture.textureType = .type2D
        albedoTexture.arrayLength = 1
        
        let roughnessTexture = MTLArgumentDescriptor()
        roughnessTexture.dataType = .texture
        roughnessTexture.index = 1
        roughnessTexture.access = .readOnly
        roughnessTexture.textureType = .type2D
        roughnessTexture.arrayLength = 1
        
        let normalsTexture = MTLArgumentDescriptor()
        normalsTexture.dataType = .texture
        normalsTexture.index = 2
        normalsTexture.access = .readOnly
        normalsTexture.textureType = .type2D
        normalsTexture.arrayLength = 1
        
        let metallicTexture = MTLArgumentDescriptor()
        metallicTexture.dataType = .texture
        metallicTexture.index = 3
        metallicTexture.access = .readOnly
        metallicTexture.textureType = .type2D
        metallicTexture.arrayLength = 1
        
        let encoder = albedo.device.makeArgumentEncoder(arguments: [albedoTexture, roughnessTexture, normalsTexture, metallicTexture])!
        
        
        let requiredSize = encoder.encodedLength
        let argumentBuffer = albedo.device.makeBuffer(length: requiredSize,
                                                      options: [.storageModeShared])!
        
        encoder.setArgumentBuffer(argumentBuffer, offset: 0)
        encoder.setTexture(albedo, index: 0)
        encoder.setTexture(roughness, index: 1)
        encoder.setTexture(normals, index: 2)
        encoder.setTexture(metallic, index: 3)
        
        self.argumentBuffer = argumentBuffer
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
