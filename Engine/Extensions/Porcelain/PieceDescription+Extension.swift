//
//  Copyright © 2021 Mateusz Stompór. All rights reserved.
//

import Metal

extension PNRamPieceDescription {
    func upload(device: MTLDevice) -> PNGPUPieceDescription? {
        guard let drawDescription = drawDescription.upload(device: device) else {
            return nil
        }
        return PNGPUPieceDescription(material: material,
                                     drawDescription: drawDescription)
    }
}
