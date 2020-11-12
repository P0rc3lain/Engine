//
//  GeometryLoader.swift
//  Porcelain
//
//  Created by Mateusz Stompór on 07/11/2020.
//

import MetalKit
import ShaderTypes

public class GeometryLoader {
    // MARK: - Properties
    private let device: MTLDevice
    // MARK: - Initialization
    public init(device: MTLDevice) {
        self.device = device
    }
    public func loadGeometries(meshes: [MTKMesh]) -> [Geometry] {
        return meshes.map { mesh in
            let buffer = DataBuffer(buffer: mesh.vertexBuffers[0].buffer,
                                    length: mesh.vertexBuffers[0].length,
                                    offset: mesh.vertexBuffers[0].offset)
            let drawDescriptions = mesh.submeshes.map { submesh -> IndexBasedDraw in
                let indexBuffer = DataBuffer(buffer: submesh.indexBuffer.buffer,
                                             length: submesh.indexBuffer.length,
                                             offset: submesh.indexBuffer.offset)
                return IndexBasedDraw(indexBuffer: indexBuffer,
                                      indexCount: submesh.indexCount,
                                      indexType: submesh.indexType,
                                      primitiveType: submesh.primitiveType)
            }
            return Geometry(vertexBuffer: buffer, drawDescription: drawDescriptions)
        }
    }
}
