//
//  ModelBinder.swift
//  Engine
//
//  Created by Mateusz Stompór on 11/11/2020.
//

import ModelIO

public class ModelBinder {
    let sceneAsset: SceneAsset
    public init(sceneAsset: SceneAsset) {
        self.sceneAsset = sceneAsset
    }
    public func bounded(meshes: [MDLMesh],
                        materials: [(String, Material)],
                        geometries: [(String, Geometry)]) -> [ModelPieceDescriptor] {
        var pieces = [ModelPieceDescriptor]()
        for (meshIndex, mesh) in meshes.enumerated() {
            guard let submeshes = mesh.submeshes as? [MDLSubmesh] else {
                continue
            }
            for (submeshIndex, submesh) in submeshes.enumerated() {
                let material = materials.first { $0.0 == submesh.material!.name }!.0
                let materialIndex = materials.firstIndex { $0.0 == material }
                let geometryPiece = GeometryPieceDescriptor(geometry: meshIndex, drawDescriptor: submeshIndex)
                let piece = ModelPieceDescriptor(material: materialIndex!, piece: geometryPiece)
                pieces.append(piece)
            }
        }
        return pieces
    }
}
