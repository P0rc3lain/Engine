//
//  Geometry+Instantiation.swift
//  Engine
//
//  Created by Mateusz Stompór on 13/11/2020.
//

import Metal
import MetalBinding
import Foundation

extension Geometry2 {
    static func cube(device: MTLDevice) -> Geometry2 {
        let vertices = cubeVerticesBuffer(device: device)
        let verticesBuffer = GPUDataBuffer(buffer: vertices, length: vertices.length, offset: 0)
        let indices = cubeIndicesBuffer(device: device)
        let indicesBuffer = GPUDataBuffer(buffer: indices, length: indices.length, offset: 0)
        let drawDescription = GPUIndexBasedDraw(indexBuffer: indicesBuffer,
                                             indexCount: indices.length,
                                             indexType: .uint16,
                                             primitiveType: .triangle)
        return Geometry2(vertexBuffer: verticesBuffer, drawDescription: [drawDescription])
    }
    private static var cubeIndices: [UInt16] = [
        0,  3,  2,  2,  1,  0,
        4,  7,  6,  6,  5,  4,
        8, 11, 10, 10,  9,  8,
       12, 15, 14, 14, 13, 12,
       16, 19, 18, 18, 17, 16,
       20, 23, 22, 22, 21, 20,
   ]
    private static var cubeVertices: [Float] = [
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
    private static func cubeVerticesBuffer(device: MTLDevice) -> MTLBuffer {
        cubeVertices.withUnsafeBytes { ptr in
            device.makeBuffer(bytes: ptr.baseAddress!, length: ptr.count, options: [.storageModeShared])!
        }
    }
    private static func cubeIndicesBuffer(device: MTLDevice) -> MTLBuffer {
        cubeIndices.withUnsafeBytes { ptr in
            device.makeBuffer(bytes: ptr.baseAddress!, length: ptr.count, options: [.storageModeShared])!
        }
    }
}
