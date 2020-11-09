//
//  ModelLoader.swift
//  Porcelain
//
//  Created by Mateusz Stompór on 07/11/2020.
//

import MetalKit
import PorcelainTypes

public struct ModelLoader {
    // MARK: - Properties
    private let device: MTLDevice
    // MARK: - Initialization
    public init(device: MTLDevice) {
        self.device = device
    }
    public func loadAsset(name: String, extension: String) -> MDLAsset? {
        let vertexDescriptor = MDLVertexDescriptor()
        vertexDescriptor.layouts = [MDLVertexBufferLayout(stride: MemoryLayout<VertexP3N3>.stride)]
        vertexDescriptor.attributes = [
            MDLVertexAttribute(name: MDLVertexAttributePosition,
                               format: .float3,
                               offset: MemoryLayout<VertexP3N3>.offset(of: \VertexP3N3.position)!,
                               bufferIndex: 0),
            MDLVertexAttribute(name: MDLVertexAttributeNormal,
                               format: .float3,
                               offset: MemoryLayout<VertexP3N3>.offset(of: \VertexP3N3.normal)!,
                               bufferIndex: 0)
        ]
        guard let url = Bundle.main.url(forResource: name, withExtension: `extension`) else {
            return nil
        }
        let allocator = MTKMeshBufferAllocator(device: device)
        return MDLAsset(url: url, vertexDescriptor: vertexDescriptor, bufferAllocator: allocator)
    }
}
