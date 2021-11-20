//
//  Copyright © 2021 Mateusz Stompór. All rights reserved.
//

import Metal

extension RamPieceDescription {
    func upload(device: MTLDevice) -> GPUPieceDescription? {
        guard let drawDescription = drawDescription.upload(device: device) else {
            return nil
        }
        return GPUPieceDescription(material: material,
                                   drawDescription: drawDescription)
    }
}
