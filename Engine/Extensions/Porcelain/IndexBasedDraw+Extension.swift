//
//  Copyright © 2021 Mateusz Stompór. All rights reserved.
//

import Metal

extension RamIndexBasedDraw  {
    func upload(device: MTLDevice) -> GPUIndexBasedDraw? {
        guard let buffer = indexBuffer.upload(device: device) else {
            return nil
        }
        return GPUIndexBasedDraw(indexBuffer: buffer,
                                 indexCount: indexCount,
                                 indexType: indexType.metal,
                                 primitiveType: primitiveType.metal)
    }
}
