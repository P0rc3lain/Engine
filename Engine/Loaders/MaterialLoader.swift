//
//  MaterialLoader.swift
//  Engine
//
//  Created by Mateusz Stompór on 11/11/2020.
//

import ModelIO
import MetalKit
import Foundation

public class MaterialLoader {
    // MARK: - Properties
    private let device: MTLDevice
    private let loader: MTKTextureLoader
    // MARK: - Initialization
    public init(device: MTLDevice) {
        self.device = device
        self.loader = MTKTextureLoader(device: device)
    }
    // MARK: - Public
    public func loadMaterials(meshes: [MDLMesh]) -> [(name: String, material: Material)]? {
        var materials = [(String, Material)]()
        for mesh in meshes {
            guard let submeshes = mesh.submeshes as? [MDLSubmesh] else {
                continue
            }
            for submesh in submeshes {
                guard let material = submesh.material, !materials.contains(where: { $0.0 == material.name }) else {
                    continue
                }
                materials.append((material.name, convert(material: material)))
            }
        }
        return materials
    }
    // MARK: - Private
    private func loadTexture(property: MDLMaterialProperty) -> MDLTexture? {
        if let sourceTexture = property.textureSamplerValue?.texture {
            return sourceTexture
        } else if let stringValue = property.stringValue, let filename = stringValue.split(separator: "/").last {
            return MDLTexture(named: String(filename))
        }
        return nil
    }
    private func storedTexture(for semantic: MDLMaterialSemantic, in material: MDLMaterial) -> MTLTexture? {
        guard let materialProperty = material.property(with: semantic) else { return nil }
        if let sourceTexture = loadTexture(property: materialProperty) {
            let generateMips = Self.shouldGenerateMipMaps(semantic: semantic)
            let options: [MTKTextureLoader.Option : Any] = [.generateMipmaps : generateMips]
            return try? loader.newTexture(texture: sourceTexture, options: options)
        }
        return nil
    }
    private func defaultColor(for semantic: MDLMaterialSemantic) -> simd_float4 {
        switch semantic {
        case .baseColor:
            return simd_float4.deafultBaseColor
        case .tangentSpaceNormal, .bump:
            return simd_float4.deafultNormalsColor
        case .roughness, .specularExponent:
            return simd_float4.deafultRoughnessColor
        case .metallic:
            return simd_float4.defaultMetallicColor
        default:
            fatalError("Default for \(semantic) not provided")
        }
    }
    private func singleColorTexture(for semantic: MDLMaterialSemantic) -> MTLTexture? {
        device.makeSolid2DTexture(color: defaultColor(for: semantic))
    }
    private func defaultTexture(for semantic: MDLMaterialSemantic, material: MDLMaterial) -> MTLTexture {
        let associatedTexture = Self.aliases(semantic: semantic).map { storedTexture(for: $0, in: material) }.filter { $0 != nil }
        let texture = (associatedTexture.count > 0 ? associatedTexture.first! : nil) ?? singleColorTexture(for: semantic)!
        texture.label = semantic.label
        return texture
    }
    private func convert(material: MDLMaterial) -> Material {
        let albedo = defaultTexture(for: .baseColor, material: material)
        let roughness = defaultTexture(for: .roughness, material: material)
        let normals = defaultTexture(for: .tangentSpaceNormal, material: material)
        let metallic = defaultTexture(for: .metallic, material: material)
        return Material(albedo: albedo, roughness: roughness, normals: normals, metallic: metallic)
    }
    static func aliases(semantic: MDLMaterialSemantic) -> [MDLMaterialSemantic] {
        switch semantic {
        case .roughness:
            return [.roughness, .specularExponent]
        default:
            return [semantic]
        }
    }
    static func shouldGenerateMipMaps(semantic: MDLMaterialSemantic) -> Bool {
        semantic != .tangentSpaceNormal
    }
}
