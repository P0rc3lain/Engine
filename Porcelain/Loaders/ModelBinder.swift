//
//  ModelBinder.swift
//  Porcelain
//
//  Created by Mateusz Stompór on 11/11/2020.
//

import ModelIO

public class ModelBinder {
    // MARK: - Properties
    private let meshes: [MDLMesh]
    // MARK: - Initialization
    public init(meshes: [MDLMesh]) {
        self.meshes = meshes
    }
    public func bounded(materials: [String: Material], models: [Geometry]) -> [ModelPiece] {
        var pieces = [ModelPiece]()
        for (index, mesh) in meshes.enumerated() {
            guard let submeshes = mesh.submeshes as? [MDLSubmesh] else {
                continue
            }
            for submesh in submeshes {
                let material = materials[submesh.material!.name]!
                let geometry = models[index]
                let piece = ModelPiece(material: material, geometry: geometry)
                pieces.append(piece)
            }
        }
        return pieces
    }
}
