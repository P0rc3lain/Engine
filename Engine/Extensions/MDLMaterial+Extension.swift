//
//  MDLMaterial.swift
//  Binarizer
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
    private func defaultTexture(for semantic: MDLMaterialSemantic) -> Texture {
        let associatedTexture = semantic.aliases.map { storedTexture(for: $0) }.filter { $0 != nil }
        guard associatedTexture.count > 0, let texture = associatedTexture.first else {
            return Texture.solid2D(color: semantic.defaultColor)
        }
        var txt = texture!.porcelain!
        txt.texture = texture
        return txt
    }
}
