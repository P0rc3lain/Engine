//
//  ModelLoader.swift
//  Porcelain
//
//  Created by Mateusz Stompór on 07/11/2020.
//

import MetalKit
import ShaderTypes

public struct ModelLoader {
    // MARK: - Properties
    private let device: MTLDevice
    // MARK: - Initialization
    public init(device: MTLDevice) {
        self.device = device
    }
    public func loadAsset(name: String, extension: String) -> MDLAsset? {
        let vertexDescriptor = MDLVertexDescriptor()
        vertexDescriptor.layouts = [MDLVertexBufferLayout(stride: MemoryLayout<VertexP3N3T2>.stride)]
        vertexDescriptor.attributes = [
            MDLVertexAttribute(name: MDLVertexAttributePosition,
                               format: .float3,
                               offset: MemoryLayout<VertexP3N3T2>.offset(of: \VertexP3N3T2.position)!,
                               bufferIndex: 0),
            MDLVertexAttribute(name: MDLVertexAttributeNormal,
                               format: .float3,
                               offset: MemoryLayout<VertexP3N3T2>.offset(of: \VertexP3N3T2.normal)!,
                               bufferIndex: 0),
            MDLVertexAttribute(name: MDLVertexAttributeTextureCoordinate,
                               format: .float2,
                               offset: MemoryLayout<VertexP3N3T2>.offset(of: \VertexP3N3T2.textureUV)!,
                               bufferIndex: 0)
        ]
        guard let url = Bundle.main.url(forResource: name, withExtension: `extension`) else {
            return nil
        }
        let allocator = MTKMeshBufferAllocator(device: device)
        let asset = MDLAsset(url: url, vertexDescriptor: vertexDescriptor, bufferAllocator: allocator)
        return asset
    }
    public func loadGeometries(asset: MDLAsset) -> [Geometry]? {
        guard let meshes = try? MTKMesh.newMeshes(asset: asset, device: device).metalKitMeshes else {
            return nil
        }
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
