//
//  Copyright © 2021 Mateusz Stompór. All rights reserved.
//

public struct PNPieceDescription {
    public let material: PNMaterial?
    public let drawDescription: PNSubmesh
    public init(material: PNMaterial? = nil,
                drawDescription: PNSubmesh) {
        self.material = material
        self.drawDescription = drawDescription
    }
}
