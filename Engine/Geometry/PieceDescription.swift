//
//  Copyright © 2021 Mateusz Stompór. All rights reserved.
//

public struct PieceDescription<DataType, IndexType, GeometryType> {
    // MARK: - Properties
    public let materialIdx: Int
    public let drawDescription: IndexBasedDraw<DataType, IndexType, GeometryType>
    // MARK: - Initialization
    public init(materialIdx: Int,
                drawDescription: IndexBasedDraw<DataType, IndexType, GeometryType>) {
        self.materialIdx = materialIdx
        self.drawDescription = drawDescription
    }
}
