//
//  Geometry.swift
//  Engine
//
//  Created by Mateusz Stompór on 10/11/2020.
//

import Foundation

public struct Geometry {
    // MARK: - Properties
    let vertexBuffer: DataBuffer
    let drawDescription: [IndexBasedDraw]
    // MARK: - Initialization
    init(vertexBuffer: DataBuffer, drawDescription: [IndexBasedDraw]) {
        self.vertexBuffer = vertexBuffer
        self.drawDescription = drawDescription
    }
}
