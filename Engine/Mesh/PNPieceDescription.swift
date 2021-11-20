//
//  Copyright © 2021 Mateusz Stompór. All rights reserved.
//

public struct PNPieceDescription<DataType, IndexType, GeometryType> {
    public let material: PNMaterial?
    public let drawDescription: PNSubmesh<DataType, IndexType, GeometryType>
    public init(material: PNMaterial?,
                drawDescription: PNSubmesh<DataType, IndexType, GeometryType>) {
        self.material = material
        self.drawDescription = drawDescription
    }
}
