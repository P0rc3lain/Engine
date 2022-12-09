//
//  Copyright © 2021 Mateusz Stompór. All rights reserved.
//

public final class PNMesh {
    public let boundingBox: PNBoundingBox
    public let vertexBuffer: PNDataBuffer
    public var pieceDescriptions: [PNPieceDescription]
    public let culling: PNCulling
    public init(boundingBox: PNBoundingBox,
                vertexBuffer: PNDataBuffer,
                pieceDescriptions: [PNPieceDescription],
                culling: PNCulling) {
        self.boundingBox = boundingBox
        self.vertexBuffer = vertexBuffer
        self.pieceDescriptions = pieceDescriptions
        self.culling = culling
    }
}
