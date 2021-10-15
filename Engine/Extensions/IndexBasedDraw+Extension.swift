//
//  Extension+IndexBasedDraw.swift
//  Uploader
//
//  Created by Mateusz Stompór on 14/10/2021.
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
