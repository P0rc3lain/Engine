//
//  Copyright © 2021 Mateusz Stompór. All rights reserved.
//

public struct PieceDescription<DataType, IndexType, GeometryType> {
    public let material: PNMaterial?
    public let drawDescription: IndexBasedDraw<DataType, IndexType, GeometryType>
    public init(material: PNMaterial?,
                drawDescription: IndexBasedDraw<DataType, IndexType, GeometryType>) {
        self.material = material
        self.drawDescription = drawDescription
    }
}
