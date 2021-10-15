//
//  Extension+Geometry.swift
//  Uploader
//
//  Created by Mateusz Stompór on 14/10/2021.
//

import Metal

extension RamGeometry {
    func upload(device: MTLDevice) -> GPUGeometry? {
        let descriptions = pieceDescriptions.compactMap{ $0.upload(device: device) }
        guard descriptions.count == pieceDescriptions.count,
              let buffer = vertexBuffer.upload(device: device) else {
            return nil
        }
        return GPUGeometry(vertexBuffer: buffer, pieceDescriptions: descriptions)
    }
}
