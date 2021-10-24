//
//  Extension+DataBuffer.swift
//  Engine
//
//  Created by Mateusz Stompór on 14/10/2021.
//

import Metal

extension RamDataBuffer {
    func upload(device: MTLDevice) -> GPUDataBuffer? {
        guard let mtlBuffer = device.makeBuffer(length: length,
                                                options: .storageModeShared) else {
            return nil
        }
        let mtlBufferPtr = mtlBuffer.contents()
        buffer.withUnsafeBytes { (ptr: UnsafeRawBufferPointer) in
            mtlBufferPtr.copyMemory(from: ptr.baseAddress!, byteCount: length)
        }
        return GPUDataBuffer(buffer: mtlBuffer, length: length, offset: offset)
    }
}
