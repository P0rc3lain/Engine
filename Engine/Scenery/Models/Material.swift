//
//  Material.swift
//  Engine
//
//  Created by Mateusz Stompór on 10/11/2020.
//

import Metal

public class Material {
    // MARK: - Properties
    let albedo: MTLTexture
    let roughness: MTLTexture
    let normals: MTLTexture
    let metallic: MTLTexture
    // MARK: - Initialization
    public init(albedo: MTLTexture, roughness: MTLTexture, normals: MTLTexture, metallic: MTLTexture) {
        self.albedo = albedo
        self.roughness = roughness
        self.normals = normals
        self.metallic = metallic
    }
}
