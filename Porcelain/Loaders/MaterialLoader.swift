//
//  MaterialLoader.swift
//  Porcelain
//
//  Created by Mateusz Stompór on 11/11/2020.
//

import ModelIO
import MetalKit
import Foundation

public class MaterialLoader {
    // MARK: - Properties
    private let device: MTLDevice
    // MARK: - Initialization
    public init(device: MTLDevice) {
        self.device = device
    }
    // MARK: - Public
    public func loadMaterials(asset: MDLAsset) -> [String: Material]? {
        asset.loadTextures()
        let loader = MTKTextureLoader(device: device)
        guard let meshes = try? MTKMesh.newMeshes(asset: asset, device: device).modelIOMeshes else {
            return nil
        }
        var materials = [String: Material]()
        for mesh in meshes {
            guard let submeshes = mesh.submeshes as? [MDLSubmesh] else {
                continue
            }
            for submesh in submeshes {
                guard let material = submesh.material else {
                    continue
                }
                materials[material.name] = convert(loader: loader, material: material)
            }
        }
        return materials
    }
    // MARK: - Private
    private func texture(for semantic: MDLMaterialSemantic, in material: MDLMaterial, loader: MTKTextureLoader) -> MTLTexture? {
        guard let materialProperty = material.property(with: semantic) else { return nil }
        guard let sourceTexture = materialProperty.textureSamplerValue?.texture else { return nil }
        let wantsMips = materialProperty.semantic != .tangentSpaceNormal
        let options: [MTKTextureLoader.Option : Any] = [.generateMipmaps : wantsMips]
        return try? loader.newTexture(texture: sourceTexture, options: options)
    }
    private func convert(loader: MTKTextureLoader, material: MDLMaterial) -> Material {
        let albedo = texture(for: .baseColor,
                             in: material,
                             loader: loader)!
        let roughness = texture(for: .roughness,
                             in: material,
                             loader: loader)!
        let normals = texture(for: .tangentSpaceNormal,
                             in: material,
                             loader: loader)!
        let metallic = texture(for: .metallic,
                             in: material,
                             loader: loader)!
        let emission = texture(for: .emission,
                               in: material,
                               loader: loader) ?? device.makeSolidTexture(device: device,
                                                                          color: simd_float4(0, 0, 0, 1))!
        return Material(albedo: albedo, roughness: roughness,
                        emission: emission, normals: normals, metallic: metallic)
    }
}
