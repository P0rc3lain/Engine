//
//  Copyright © 2021 Mateusz Stompór. All rights reserved.
//

import Metal

extension RamDataBuffer {
    func upload(device: MTLDevice) -> GPUDataBuffer? {
        guard let deviceBuffer = device.makeBuffer(data: buffer) else {
            return nil
        }
        return GPUDataBuffer(buffer: deviceBuffer, length: length, offset: offset)
    }
}
