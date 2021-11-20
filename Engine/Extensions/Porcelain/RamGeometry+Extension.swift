//
//  Copyright © 2021 Mateusz Stompór. All rights reserved.
//

import Metal

extension RamGeometry {
    func upload(device: MTLDevice) -> GPUGeometry? {
        let descriptions = pieceDescriptions.compactMap { $0.upload(device: device) }
        guard descriptions.count == pieceDescriptions.count,
              let buffer = vertexBuffer.upload(device: device) else {
            return nil
        }
        return GPUGeometry(name: name,
                           vertexBuffer: buffer,
                           pieceDescriptions: descriptions)
    }
}
