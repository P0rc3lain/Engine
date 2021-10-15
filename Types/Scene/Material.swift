//
//  Material.swift
//  Types
//
//  Created by Mateusz Stompór on 11/10/2021.
//

public struct Material<DataType> {
    // MARK: - Properties
    public let albedo: DataType
    public let roughness: DataType
    public let normals: DataType
    public let metallic: DataType
    // MARK: - Initialization
    public init(albedo: DataType, roughness: DataType,
                normals: DataType, metallic: DataType) {
        self.albedo = albedo
        self.roughness = roughness
        self.normals = normals
        self.metallic = metallic
    }
}
