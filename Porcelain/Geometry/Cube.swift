//
//  Geometry.swift
//  Porcelain
//
//  Created by Mateusz Stompór on 07/11/2020.
//

import MetalKit

struct Cube {
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
        -0.5,  0.5,  0.5, 1.0,  0.0, -1.0,  0.0, 0.0,
         0.5,  0.5,  0.5, 1.0,  0.0, -1.0,  0.0, 0.0,
         0.5,  0.5, -0.5, 1.0,  0.0, -1.0,  0.0, 0.0,
        -0.5,  0.5, -0.5, 1.0,  0.0, -1.0,  0.0, 0.0,
        // -Y
        -0.5, -0.5, -0.5, 1.0,  0.0,  1.0,  0.0, 0.0,
         0.5, -0.5, -0.5, 1.0,  0.0,  1.0,  0.0, 0.0,
         0.5, -0.5,  0.5, 1.0,  0.0,  1.0,  0.0, 0.0,
        -0.5, -0.5,  0.5, 1.0,  0.0,  1.0,  0.0, 0.0,
        // +Z
        -0.5, -0.5,  0.5, 1.0,  0.0,  0.0, -1.0, 0.0,
         0.5, -0.5,  0.5, 1.0,  0.0,  0.0, -1.0, 0.0,
         0.5,  0.5,  0.5, 1.0,  0.0,  0.0, -1.0, 0.0,
        -0.5,  0.5,  0.5, 1.0,  0.0,  0.0, -1.0, 0.0,
        // -Z
         0.5, -0.5, -0.5, 1.0,  0.0,  0.0,  1.0, 0.0,
        -0.5, -0.5, -0.5, 1.0,  0.0,  0.0,  1.0, 0.0,
        -0.5,  0.5, -0.5, 1.0,  0.0,  0.0,  1.0, 0.0,
         0.5,  0.5, -0.5, 1.0,  0.0,  0.0,  1.0, 0.0,
        // -X
        -0.5, -0.5, -0.5, 1.0,  1.0,  0.0,  0.0, 0.0,
        -0.5, -0.5,  0.5, 1.0,  1.0,  0.0,  0.0, 0.0,
        -0.5,  0.5,  0.5, 1.0,  1.0,  0.0,  0.0, 0.0,
        -0.5,  0.5, -0.5, 1.0,  1.0,  0.0,  0.0, 0.0,
        // +X
         0.5, -0.5,  0.5, 1.0, -1.0,  0.0,  0.0, 0.0,
         0.5, -0.5, -0.5, 1.0, -1.0,  0.0,  0.0, 0.0,
         0.5,  0.5, -0.5, 1.0, -1.0,  0.0,  0.0, 0.0,
         0.5,  0.5,  0.5, 1.0, -1.0,  0.0,  0.0, 0.0,
    ]
    static func verticesBuffer(device: MTLDevice) -> MTLBuffer {
        Cube.vertices.withUnsafeBytes { ptr in
            let verticesBuffer = device.makeBuffer(bytes: ptr.baseAddress!,
                                                  length: ptr.count,
                                                  options: [.storageModeShared])
            return verticesBuffer!
        }
    }
    static func indicesBuffer(device: MTLDevice) -> MTLBuffer {
        Cube.indices.withUnsafeBytes { ptr in
            let indicesBuffer = device.makeBuffer(bytes: ptr.baseAddress!,
                                                  length: ptr.count,
                                                  options: [.storageModeShared])
            return indicesBuffer!
        }
    }
}
