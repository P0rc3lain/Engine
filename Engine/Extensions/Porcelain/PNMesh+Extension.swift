//
//  Copyright © 2021 Mateusz Stompór. All rights reserved.
//

import Metal
import MetalBinding
import ModelIO

extension PNMesh {
    static func cube(device: MTLDevice) -> PNMesh? {
        guard let vertices = device.makeBuffer(array: cubeVertices),
              let indices = device.makeBuffer(array: cubeIndices) else {
            return nil
        }
        let verticesBuffer = PNDataBuffer(buffer: vertices, length: vertices.length)
        let indicesBuffer = PNDataBuffer(buffer: indices, length: indices.length)
        let drawDescription = PNSubmesh(indexBuffer: indicesBuffer,
                                        indexCount: indices.length,
                                        indexType: .uint16,
                                        primitiveType: .triangle)
        let pieceDescription = PNPieceDescription(material: nil,
                                                  drawDescription: drawDescription)
        let boundingBox = PNIBoundingBoxInteractor.default.from(bound: PNBound(min: [-0.5, -0.5, -0.5],
                                                                               max: [0.5, 0.5, 0.5]))
        return PNMesh(boundingBox: boundingBox,
                      vertexBuffer: verticesBuffer,
                      pieceDescriptions: [pieceDescription])
    }
    private static var cubeIndices: [UInt16] = [
        0, 3, 2, 2, 1, 0,
        4, 7, 6, 6, 5, 4,
        8, 11, 10, 10, 9, 8,
       12, 15, 14, 14, 13, 12,
       16, 19, 18, 18, 17, 16,
       20, 23, 22, 22, 21, 20
    ]
    private static var cubeVertices: [VertexP] = [
        // + Y
        VertexP(-0.5, 0.5, 0.5),
        VertexP(0.5, 0.5, 0.5),
        VertexP(0.5, 0.5, -0.5),
        VertexP(-0.5, 0.5, -0.5),
        // -Y
        VertexP(-0.5, -0.5, -0.5),
        VertexP(0.5, -0.5, -0.5),
        VertexP(0.5, -0.5, 0.5),
        VertexP(-0.5, -0.5, 0.5),
        // +Z
        VertexP(-0.5, -0.5, 0.5),
        VertexP(0.5, -0.5, 0.5),
        VertexP(0.5, 0.5, 0.5),
        VertexP(-0.5, 0.5, 0.5),
        // -Z
        VertexP(0.5, -0.5, -0.5),
        VertexP(-0.5, -0.5, -0.5),
        VertexP(-0.5, 0.5, -0.5),
        VertexP(0.5, 0.5, -0.5),
        // -X
        VertexP(-0.5, -0.5, -0.5),
        VertexP(-0.5, -0.5, 0.5),
        VertexP(-0.5, 0.5, 0.5),
        VertexP(-0.5, 0.5, -0.5),
        // +X
        VertexP(0.5, -0.5, 0.5),
        VertexP(0.5, -0.5, -0.5),
        VertexP(0.5, 0.5, -0.5),
        VertexP(0.5, 0.5, 0.5)
    ]
    static func screenSpacePlane(device: MTLDevice) -> PNMesh? {
        guard let indices = device.makeBuffer(array: planeIndices),
              let vertices = device.makeBuffer(array: planeVertices) else {
            return nil
        }
        let indicesBuffer = PNDataBuffer(buffer: indices, length: indices.length, offset: indices.offset)
        let verticesBuffer = PNDataBuffer(buffer: vertices, length: vertices.length, offset: vertices.offset)
        let drawDescription = PNSubmesh(indexBuffer: indicesBuffer,
                                        indexCount: indicesBuffer.length / MemoryLayout<UInt16>.stride,
                                        indexType: .uint16,
                                        primitiveType: .triangle)
        let pieceDescription = PNPieceDescription(material: nil,
                                                  drawDescription: drawDescription)
        let interactor = PNIBoundingBoxInteractor.default
        return PNMesh(boundingBox: interactor.from(bound: PNBound(min: [-1, -1, 0],
                                                                  max: [1, 1, 0])),
                      vertexBuffer: verticesBuffer,
                      pieceDescriptions: [pieceDescription])
    }
    private static var planeVertices: [VertexPUV] = [
        VertexPUV(position: simd_float3(-1, -1, 0),
                  textureUV: simd_float2(0, 1)),
        VertexPUV(position: simd_float3(1, -1, 0),
                  textureUV: simd_float2(1, 1)),
        VertexPUV(position: simd_float3(-1, 1, 0),
                  textureUV: simd_float2(0, 0)),
        VertexPUV(position: simd_float3(1, 1, 0),
                  textureUV: simd_float2(1, 0))
    ]
    private static var planeIndices: [UInt16] = [
        0, 1, 2,
        1, 3, 2
    ]
}