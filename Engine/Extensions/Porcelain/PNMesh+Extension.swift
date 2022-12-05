//
//  Copyright © 2021 Mateusz Stompór. All rights reserved.
//

import Metal
import PNShared
import ModelIO

extension PNMesh {
    static func cube(device: MTLDevice) -> PNMesh? {
        guard let vertices = device.makeBuffer(array: cubeVertices),
              let indices = device.makeBuffer(array: cubeIndices) else {
            assertionFailure("Could not create buffers for the mesh")
            return nil
        }
        let verticesBuffer = PNDataBuffer(wholeBuffer: vertices)
        let indicesBuffer = PNDataBuffer(wholeBuffer: indices)
        let drawDescription = PNSubmesh(indexBuffer: indicesBuffer,
                                        indexCount: indices.length / MemoryLayout<UInt16>.stride,
                                        indexType: .uint16,
                                        primitiveType: .triangle)
        let pieceDescription = PNPieceDescription(drawDescription: drawDescription)
        let boundingBox = PNIBoundingBoxInteractor.default.from(bound: PNBound(min: [-0.5, -0.5, -0.5],
                                                                               max: [0.5, 0.5, 0.5]))
        return PNMesh(boundingBox: boundingBox,
                      vertexBuffer: verticesBuffer,
                      pieceDescriptions: [pieceDescription],
                      culling: PNCulling(frontCulling: .front,
                                         backCulling: .back,
                                         winding: .counterClockwise))
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
    public static func plane(device: MTLDevice, material: PNMaterial? = nil) -> PNMesh? {
        guard let indices = device.makeBuffer(array: planeIndices),
              let vertices = device.makeBuffer(array: planeVertices) else {
            assertionFailure("Could not create buffers for the mesh")
            return nil
        }
        let indicesBuffer = PNDataBuffer(wholeBuffer: indices)
        let verticesBuffer = PNDataBuffer(wholeBuffer: vertices)
        let drawDescription = PNSubmesh(indexBuffer: indicesBuffer,
                                        indexCount: indicesBuffer.length / MemoryLayout<UInt16>.stride,
                                        indexType: .uint16,
                                        primitiveType: .triangle)
        let pieceDescription = PNPieceDescription(drawDescription: drawDescription,
                                                  material: material)
        let interactor = PNIBoundingBoxInteractor.default
        return PNMesh(boundingBox: interactor.from(bound: PNBound(min: [-1, -1, 0],
                                                                  max: [1, 1, 0])),
                      vertexBuffer: verticesBuffer,
                      pieceDescriptions: [pieceDescription],
                      culling: PNCulling(frontCulling: .front,
                                         backCulling: .back,
                                         winding: .counterClockwise))
    }
    private static var planeVertices: [Vertex] = [
        Vertex(position: simd_float3(-1, -1, 0),
               normal: [0, 0, -1],
               tangent: [0, 1, 0],
               textureUV: simd_float2(0, 1)),
        Vertex(position: simd_float3(1, -1, 0),
               normal: [0, 0, -1],
               tangent: [0, 1, 0],
               textureUV: simd_float2(1, 1)),
        Vertex(position: simd_float3(-1, 1, 0),
               normal: [0, 0, -1],
               tangent: [0, 1, 0],
               textureUV: simd_float2(0, 0)),
        Vertex(position: simd_float3(1, 1, 0),
               normal: [0, 0, -1],
               tangent: [0, 1, 0],
               textureUV: simd_float2(1, 0))
    ]
    private static var planeIndices: [UInt16] = [
        0, 1, 2,
        1, 3, 2
    ]
}
