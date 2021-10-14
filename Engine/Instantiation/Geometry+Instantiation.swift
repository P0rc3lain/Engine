//
//  Geometry+Instantiation.swift
//  Porcelain
//
//  Created by Mateusz Stompór on 13/11/2020.
//

import Metal
import ShaderTypes
import Foundation

extension Geometry {
    static func cube(device: MTLDevice) -> Geometry {
        let vertices = cubeVerticesBuffer(device: device)
        let verticesBuffer = DataBuffer(buffer: vertices, length: vertices.length, offset: 0)
        let indices = cubeIndicesBuffer(device: device)
        let indicesBuffer = DataBuffer(buffer: indices, length: indices.length, offset: 0)
        let drawDescription = IndexBasedDraw(indexBuffer: indicesBuffer,
                                             indexCount: indices.length,
                                             indexType: .uint16,
                                             primitiveType: .triangle)
        return Geometry(vertexBuffer: verticesBuffer, drawDescription: [drawDescription])
    }
    static func screenSpacePlane(device: MTLDevice) -> Geometry {
        let indices = planeIndicesBuffer(device: device)
        let indicesBuffer = DataBuffer(buffer: indices, length: indices.length, offset: indices.heapOffset)
        let vertices = planeVerticesBuffer(device: device)
        let verticesBuffer = DataBuffer(buffer: vertices, length: vertices.length, offset: vertices.heapOffset)
        let drawDescription = IndexBasedDraw(indexBuffer: indicesBuffer,
                                             indexCount: indicesBuffer.length / MemoryLayout<UInt16>.stride,
                                             indexType: .uint16,
                                             primitiveType: .triangle)
        return Geometry(vertexBuffer: verticesBuffer, drawDescription: [drawDescription])
    }
    private static var planeVertices: [Vertex] = [
        Vertex(position: simd_float3(-1, -1, 0), normal: simd_float3(0, 0, 1), tangent: simd_float3(0, 1, 0), textureUV: simd_float2(0, 1)),
        Vertex(position: simd_float3(1, -1, 0), normal: simd_float3(0, 0, 1), tangent: simd_float3(0, 1, 0), textureUV: simd_float2(1, 1)),
        Vertex(position: simd_float3(-1, 1, 0), normal: simd_float3(0, 0, 1), tangent: simd_float3(0, 1, 0), textureUV: simd_float2(0, 0)),
        Vertex(position: simd_float3(1, 1, 0), normal: simd_float3(0, 0, 1), tangent: simd_float3(0, 1, 0), textureUV: simd_float2(1, 0))
    ]
    private static var planeIndices: [UInt16] = [
        0, 1, 2,
        1, 3, 2
    ]
    private static func planeVerticesBuffer(device: MTLDevice) -> MTLBuffer {
        planeVertices.withUnsafeBytes { ptr in
            device.makeBuffer(bytes: ptr.baseAddress!, length: ptr.count, options: [.storageModeShared])!
        }
    }
    private static func planeIndicesBuffer(device: MTLDevice) -> MTLBuffer {
        planeIndices.withUnsafeBytes { ptr in
            device.makeBuffer(bytes: ptr.baseAddress!, length: ptr.count, options: [.storageModeShared])!
        }
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
