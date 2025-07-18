//
//  Copyright © 2025 Mateusz Stompór. All rights reserved.
//

import Metal

struct MaterialArgumentBuffer {
    private let device: MTLDevice
    private let albedo: MTLTexture
    private let roughness: MTLTexture
    private let normals: MTLTexture
    private let metallic: MTLTexture
    
    init(device: MTLDevice,
         albedo: MTLTexture,
         roughness: MTLTexture,
         normals: MTLTexture,
         metallic: MTLTexture) {
        self.device = device
        self.albedo = albedo
        self.roughness = roughness
        self.normals = normals
        self.metallic = metallic
    }
    
    func create() -> MTLBuffer {
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
        
        let encoder = device.makeArgumentEncoder(arguments: [albedoTexture,
                                                             roughnessTexture,
                                                             normalsTexture,
                                                             metallicTexture])!
        
        
        let requiredSize = encoder.encodedLength
        let argumentBuffer = device.makeBuffer(length: requiredSize,
                                               options: [.storageModeShared])!
        
        encoder.setArgumentBuffer(argumentBuffer, offset: 0)
        
        encoder.setTexture(albedo, index: 0)
        encoder.setTexture(roughness, index: 1)
        encoder.setTexture(normals, index: 2)
        encoder.setTexture(metallic, index: 3)
        
        return argumentBuffer
    }
}
