//
//  Extension+Geometry.swift
//  Uploader
//
//  Created by Mateusz Stompór on 14/10/2021.
//

import Metal
import MetalBinding

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

extension GPUGeometry {
    static func screenSpacePlane(device: MTLDevice) -> GPUGeometry {
        let indices = planeIndicesBuffer(device: device)
        let indicesBuffer = GPUDataBuffer(buffer: indices, length: indices.length, offset: indices.heapOffset)
        let vertices = planeVerticesBuffer(device: device)
        let verticesBuffer = GPUDataBuffer(buffer: vertices, length: vertices.length, offset: vertices.heapOffset)
        let drawDescription = GPUIndexBasedDraw(indexBuffer: indicesBuffer,
                                                indexCount: indicesBuffer.length / MemoryLayout<UInt16>.stride,
                                                indexType: .uint16,
                                                primitiveType: .triangle)
        let pieceDescription = PieceDescription(materialIdx: .nil, drawDescription: drawDescription)
        return GPUGeometry(vertexBuffer: verticesBuffer, pieceDescriptions: [pieceDescription])
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
}
