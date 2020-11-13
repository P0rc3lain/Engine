//
//  Geometry+Instantion.swift
//  Porcelain
//
//  Created by Mateusz Stompór on 13/11/2020.
//

import Metal
import Foundation

extension Geometry {
    static func cube(device: MTLDevice) -> Geometry {
        let vertices = verticesBuffer(device: device)
        let verticesBuffer = DataBuffer(buffer: vertices, length: vertices.length, offset: 0)
        let indices = indicesBuffer(device: device)
        let indicesBuffer = DataBuffer(buffer: indices, length: indices.length, offset: 0)
        let drawDescription = IndexBasedDraw(indexBuffer: indicesBuffer,
                                             indexCount: indices.length,
                                             indexType: .uint16,
                                             primitiveType: .triangle)
        return Geometry(vertexBuffer: verticesBuffer, drawDescription: [drawDescription])
    }
    private static var indices: [UInt16] = [
        0,  3,  2,  2,  1,  0,
        4,  7,  6,  6,  5,  4,
        8, 11, 10, 10,  9,  8,
       12, 15, 14, 14, 13, 12,
       16, 19, 18, 18, 17, 16,
       20, 23, 22, 22, 21, 20,
   ]
    private static var vertices: [Float] = [
        // + Y
        -0.5,  0.5,  0.5, 1.0,
         0.5,  0.5,  0.5, 1.0,
         0.5,  0.5, -0.5, 1.0,
        -0.5,  0.5, -0.5, 1.0,
        // -Y
        -0.5, -0.5, -0.5, 1.0,
         0.5, -0.5, -0.5, 1.0,
         0.5, -0.5,  0.5, 1.0,
        -0.5, -0.5,  0.5, 1.0,
        // +Z
        -0.5, -0.5,  0.5, 1.0,
         0.5, -0.5,  0.5, 1.0,
         0.5,  0.5,  0.5, 1.0,
        -0.5,  0.5,  0.5, 1.0,
        // -Z
         0.5, -0.5, -0.5, 1.0,
        -0.5, -0.5, -0.5, 1.0,
        -0.5,  0.5, -0.5, 1.0,
         0.5,  0.5, -0.5, 1.0,
        // -X
        -0.5, -0.5, -0.5, 1.0,
        -0.5, -0.5,  0.5, 1.0,
        -0.5,  0.5,  0.5, 1.0,
        -0.5,  0.5, -0.5, 1.0,
        // +X
         0.5, -0.5,  0.5, 1.0,
         0.5, -0.5, -0.5, 1.0,
         0.5,  0.5, -0.5, 1.0,
         0.5,  0.5,  0.5, 1.0,
    ]
    static func verticesBuffer(device: MTLDevice) -> MTLBuffer {
        vertices.withUnsafeBytes { ptr in
            device.makeBuffer(bytes: ptr.baseAddress!, length: ptr.count, options: [.storageModeShared])!
        }
    }
    static func indicesBuffer(device: MTLDevice) -> MTLBuffer {
        indices.withUnsafeBytes { ptr in
            device.makeBuffer(bytes: ptr.baseAddress!, length: ptr.count, options: [.storageModeShared])!
        }
    }
}
