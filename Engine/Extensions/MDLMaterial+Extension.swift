//
//  MDLMaterial.swift
//  Engine
//
//  Created by Mateusz Stompór on 12/10/2021.
//

import ModelIO

extension MDLMaterial {
    var porcelain: RamMaterial {
        let albedo = defaultTexture(for: .baseColor)
        let roughness = defaultTexture(for: .roughness)
        let normals = defaultTexture(for: .tangentSpaceNormal)
        let metallic = defaultTexture(for: .metallic)
        return Material(albedo: albedo, roughness: roughness, normals: normals, metallic: metallic)
    }
    private func storedTexture(for semantic: MDLMaterialSemantic) -> MDLTexture? {
        guard let materialProperty = property(with: semantic) else { return nil }
        return materialProperty.associatedTexture
    }
    private func defaultTexture(for semantic: MDLMaterialSemantic) -> MDLTexture {
        if let associatedTexture = semantic.aliases.compactMap({ storedTexture(for: $0) }).first {
            return associatedTexture
        }
        return MDLTexture.solid2D(color: semantic.defaultColor)
    }
}
