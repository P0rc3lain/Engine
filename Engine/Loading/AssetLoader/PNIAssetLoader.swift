//
//  Copyright © 2021 Mateusz Stompór. All rights reserved.
//

import ModelIO

struct PNIAssetLoader: PNAssetLoader {
    func resource(from url: URL) -> MDLAsset? {
        guard let asset = self.retrieve(url: url) else {
            return nil
        }
        self.adjustAssetToEngineNeeds(asset: asset)
        return asset
    }
    func resource(name: String, extension: String, bundle: Bundle) -> MDLAsset? {
        guard let url = bundle.url(forResource: name, withExtension: `extension`) else {
            return nil
        }
        return self.resource(from: url)
    }
    private func retrieve(url: URL) -> MDLAsset? {
        let vertexDescriptor = MDLVertexDescriptor.porcelain
        return MDLAsset(url: url,
                        vertexDescriptor: vertexDescriptor,
                        bufferAllocator: nil)
    }
    private func adjustAssetToEngineNeeds(asset: MDLAsset) {
        asset.loadTextures()
        guard let meshes = asset.childObjects(of: MDLMesh.self) as? [MDLMesh] else {
            return
        }
        for mesh in meshes {
            try? mesh.makeVerticesUniqueAndReturnError()
            mesh.flipTextureCoordinates(inAttributeNamed: MDLVertexAttributeTextureCoordinate)
            mesh.addTangentBasis(forTextureCoordinateAttributeNamed: MDLVertexAttributeTextureCoordinate,
                                 normalAttributeNamed: MDLVertexAttributeNormal,
                                 tangentAttributeNamed: MDLVertexAttributeTangent)
        }
    }
}
