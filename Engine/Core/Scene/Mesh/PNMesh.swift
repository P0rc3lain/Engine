//
//  Copyright © 2021 Mateusz Stompór. All rights reserved.
//

/// Mesh is a 3D object representation consisting of a collection of vertices and polygons.
public final class PNMesh {
    /// The spatial bounding box that encapsulates the mesh.
    public let boundingBox: PNBoundingBox
    /// Buffer containing the vertex data used to render the mesh.
    public let vertexBuffer: PNDataBuffer
    /// Descriptions of the individual segments of the mesh.
    public var pieceDescriptions: [PNPieceDescription]
    /// Initializes a mesh with a bounding box, vertex buffer, piece descriptions, and culling strategy.
    public init(boundingBox: PNBoundingBox,
                vertexBuffer: PNDataBuffer,
                pieceDescriptions: [PNPieceDescription]) {
        self.boundingBox = boundingBox
        self.vertexBuffer = vertexBuffer
        self.pieceDescriptions = pieceDescriptions
    }
}
