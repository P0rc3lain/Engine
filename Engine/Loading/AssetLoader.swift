//
//  Copyright © 2021 Mateusz Stompór. All rights reserved.
//

import ModelIO

class AssetLoader {
    // MARK: - Internal
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
    // MARK: - Private
    private func retrieve(url: URL) -> MDLAsset? {
        let vertexDescriptor = MDLVertexDescriptor.porcelain
        let asset = MDLAsset(url: url,
                             vertexDescriptor: vertexDescriptor,
                             bufferAllocator: nil)
        return asset
    }
    private func adjustAssetToEngineNeeds(asset: MDLAsset) {
        asset.loadTextures()
        for sourceMesh in asset.childObjects(of: MDLMesh.self) as! [MDLMesh] {
            try? sourceMesh.makeVerticesUniqueAndReturnError()
            sourceMesh.flipTextureCoordinates(inAttributeNamed: MDLVertexAttributeTextureCoordinate)
            sourceMesh.addTangentBasis(forTextureCoordinateAttributeNamed: MDLVertexAttributeTextureCoordinate,
                                       normalAttributeNamed: MDLVertexAttributeNormal,
                                       tangentAttributeNamed: MDLVertexAttributeTangent)
        }
    }
}
