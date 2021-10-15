//
//  MTLVertexDescriptor.swift
//  Types
//
//  Created by Mateusz Stompór on 11/10/2021.
//

import MetalKit

extension MTLVertexDescriptor {
    // MARK: - Public
    public static var porcelain: MTLVertexDescriptor {
        MTKMetalVertexDescriptorFromModelIO(MDLVertexDescriptor.porcelain)!
    }
}
