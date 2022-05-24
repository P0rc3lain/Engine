//
//  Copyright © 2021 Mateusz Stompór. All rights reserved.
//

public final class PNMesh {
    public let boundingBox: PNBoundingBox
    public let vertexBuffer: PNDataBuffer
    public let pieceDescriptions: [PNPieceDescription]
    public init(boundingBox: PNBoundingBox,
                vertexBuffer: PNDataBuffer,
                pieceDescriptions: [PNPieceDescription]) {
        self.boundingBox = boundingBox
        self.vertexBuffer = vertexBuffer
        self.pieceDescriptions = pieceDescriptions
    }
}
