//
//  Copyright © 2021 Mateusz Stompór. All rights reserved.
//

public struct PNMesh: Identifiable {
    public let name: String
    public let boundingBox: PNBoundingBox
    public let vertexBuffer: PNDataBuffer
    public let pieceDescriptions: [PNPieceDescription]
    public init(name: String,
                boundingBox: PNBoundingBox,
                vertexBuffer: PNDataBuffer,
                pieceDescriptions: [PNPieceDescription]) {
        self.name = name
        self.boundingBox = boundingBox
        self.vertexBuffer = vertexBuffer
        self.pieceDescriptions = pieceDescriptions
    }
}
