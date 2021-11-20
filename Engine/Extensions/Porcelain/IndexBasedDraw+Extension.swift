//
//  Copyright © 2021 Mateusz Stompór. All rights reserved.
//

import Metal

extension PNRamSubmesh {
    func upload(device: MTLDevice) -> PNGPUSubmesh? {
        guard let buffer = indexBuffer.upload(device: device) else {
            return nil
        }
        return PNGPUSubmesh(indexBuffer: buffer,
                          indexCount: indexCount,
                          indexType: indexType.metal,
                          primitiveType: primitiveType.metal)
    }
}
