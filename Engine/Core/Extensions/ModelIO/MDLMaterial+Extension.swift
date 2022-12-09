//
//  Copyright © 2021 Mateusz Stompór. All rights reserved.
//

import Metal
import ModelIO

extension MDLMaterial {
    func upload(device: MTLDevice) -> PNMaterial? {
        guard let albedo = defaultTexture(for: .baseColor).upload(device: device),
              let roughness = defaultTexture(for: .roughness).upload(device: device),
              let normals = defaultTexture(for: .tangentSpaceNormal).upload(device: device),
              let metallic = defaultTexture(for: .metallic).upload(device: device) else {
            assertionFailure("Textures creation has failed")
                  return nil
        }
        return PNIMaterial(name: name,
                           albedo: albedo,
                           roughness: roughness,
                           normals: normals,
                           metallic: metallic)
    }
    private func storedTexture(for semantic: MDLMaterialSemantic) -> MDLTexture? {
        guard let materialProperty = property(with: semantic) else {
            return nil
        }
        return materialProperty.associatedTexture
    }
    private func defaultTexture(for semantic: MDLMaterialSemantic) -> MDLTexture {
        if let associatedTexture = semantic.aliases.compactMap({ storedTexture(for: $0) }).first {
            associatedTexture.name = "\(semantic.label) (Loaded)"
            return associatedTexture
        }
        return .solid2D(color: semantic.defaultColor,
                        name: "\(semantic.label) (Generated)")
    }
}
