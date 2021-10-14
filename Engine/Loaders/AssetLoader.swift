//
//  AssetLoader.swift
//  Porcelain
//
//  Created by Mateusz Stompór on 11/11/2020.
//

import ModelIO
import MetalKit

public class AssetLoader {
    // MARK: - Properties
    private let device: MTLDevice
    // MARK: - Initialization
    public init(device: MTLDevice) {
        self.device = device
    }
    public func loadAsset(name: String, extension: String) -> MDLAsset? {
        guard let url = Bundle.main.url(forResource: name, withExtension: `extension`) else {
            return nil
        }
        let allocator = MTKMeshBufferAllocator(device: device)
        let vertexDescriptor = MDLVertexDescriptor.porcelainMeshVertexDescriptor
        let asset = MDLAsset(url: url, vertexDescriptor: vertexDescriptor, bufferAllocator: allocator)
        asset.loadTextures()
        for sourceMesh in asset.childObjects(of: MDLMesh.self) as! [MDLMesh] {
            sourceMesh.flipTextureCoordinates(inAttributeNamed: MDLVertexAttributeTextureCoordinate)
            sourceMesh.addTangentBasis(forTextureCoordinateAttributeNamed: MDLVertexAttributeTextureCoordinate,
                                       normalAttributeNamed: MDLVertexAttributeNormal,
                                       tangentAttributeNamed: MDLVertexAttributeTangent)
        }
        return asset
    }
}
