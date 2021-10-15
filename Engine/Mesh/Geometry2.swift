//
//  Geometry.swift
//  Engine
//
//  Created by Mateusz Stompór on 10/11/2020.
//


public struct Geometry2 {
    // MARK: - Properties
    let vertexBuffer: GPUDataBuffer
    let drawDescription: [GPUIndexBasedDraw]
    // MARK: - Initialization
    init(vertexBuffer: GPUDataBuffer, drawDescription: [GPUIndexBasedDraw]) {
        self.vertexBuffer = vertexBuffer
        self.drawDescription = drawDescription
    }
}
