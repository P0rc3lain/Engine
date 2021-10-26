//
//  Copyright © 2021 Mateusz Stompór. All rights reserved.
//

import Metal

extension RamDataBuffer {
    func upload(device: MTLDevice) -> GPUDataBuffer? {
        guard let deviceBuffer = device.makeBuffer(length: length,
                                                options: .storageModeShared) else {
            return nil
        }
        let deviceBufferPointer = deviceBuffer.contents()
        buffer.withUnsafeBytes { (pointer: UnsafeRawBufferPointer) in
            guard let baseAddress = pointer.baseAddress else {
                fatalError("Cannot retrieve base address of the pointer")
            }
            deviceBufferPointer.copyMemory(from: baseAddress, byteCount: length)
        }
        return GPUDataBuffer(buffer: deviceBuffer, length: length, offset: offset)
    }
}
