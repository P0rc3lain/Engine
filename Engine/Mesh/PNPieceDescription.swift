//
//  Copyright © 2021 Mateusz Stompór. All rights reserved.
//

public struct PNPieceDescription {
    public let drawDescription: PNSubmesh
    public var material: PNMaterial?
    public init(drawDescription: PNSubmesh,
                material: PNMaterial? = nil) {
        self.drawDescription = drawDescription
        self.material = material
    }
}
