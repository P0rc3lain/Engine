//
//  Copyright © 2021 Mateusz Stompór. All rights reserved.
//

import Metal

extension PNRamDataBuffer {
    func upload(device: MTLDevice) -> PNGPUDataBuffer? {
        guard let deviceBuffer = device.makeBuffer(data: buffer) else {
            return nil
        }
        return PNGPUDataBuffer(buffer: deviceBuffer, length: length, offset: offset)
    }
}
