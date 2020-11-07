//
//  ModelLoader.swift
//  Porcelain
//
//  Created by Mateusz Stompór on 07/11/2020.
//

import MetalKit


struct Vertex {
    let position: vector_float3
    let normal: vector_float3
}

public struct ModelLoader {
    // MARK: - Properties
    private let device: MTLDevice
    // MARK: - Initialization
    public init(device: MTLDevice) {
        self.device = device
    }
    public func loadAsset(name: String, extension: String) -> MDLAsset? {
        let vertexDescriptor = MDLVertexDescriptor()
        let vertexLayout = MDLVertexBufferLayout()
        vertexLayout.stride = MemoryLayout<Vertex>.size
        vertexDescriptor.layouts = [vertexLayout]
        vertexDescriptor.attributes = [
            MDLVertexAttribute(name: MDLVertexAttributePosition, format: .float3, offset: 0, bufferIndex: 0),
            MDLVertexAttribute(name: MDLVertexAttributeNormal, format: .float3, offset: MemoryLayout<Vertex>.size/2, bufferIndex: 0)
        ]
        guard let url = Bundle.main.url(forResource: name, withExtension: `extension`) else {
            return nil
        }
        let allocator = MTKMeshBufferAllocator(device: device)
        return MDLAsset(url: url, vertexDescriptor: vertexDescriptor, bufferAllocator: allocator)
    }
}
