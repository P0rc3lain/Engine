//
//  Copyright © 2021 Mateusz Stompór. All rights reserved.
//

import Metal

extension PNRamMesh {
    func upload(device: MTLDevice) -> PNGPUMesh? {
        let descriptions = pieceDescriptions.compactMap { $0.upload(device: device) }
        guard descriptions.count == pieceDescriptions.count,
              let buffer = vertexBuffer.upload(device: device) else {
            return nil
        }
        return PNGPUMesh(name: name,
                         vertexBuffer: buffer,
                         pieceDescriptions: descriptions)
    }
}
