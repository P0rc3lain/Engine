//
//  ModelLoader.swift
//  Porcelain
//
//  Created by Mateusz Stompór on 07/11/2020.
//

import MetalKit


struct Vertex {
    let position: simd_float3
    let normal: simd_float3
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
        vertexDescriptor.layouts = [MDLVertexBufferLayout(stride: MemoryLayout<Vertex>.stride)]
        vertexDescriptor.attributes = [
            MDLVertexAttribute(name: MDLVertexAttributePosition,
                               format: .float3,
                               offset: MemoryLayout<Vertex>.offset(of: \Vertex.position)!,
                               bufferIndex: 0),
            MDLVertexAttribute(name: MDLVertexAttributeNormal,
                               format: .float3,
                               offset: MemoryLayout<Vertex>.offset(of: \Vertex.normal)!,
                               bufferIndex: 0)
        ]
        guard let url = Bundle.main.url(forResource: name, withExtension: `extension`) else {
            return nil
        }
        let allocator = MTKMeshBufferAllocator(device: device)
        return MDLAsset(url: url, vertexDescriptor: vertexDescriptor, bufferAllocator: allocator)
    }
}
