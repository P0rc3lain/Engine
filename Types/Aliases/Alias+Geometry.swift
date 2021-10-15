//
//  Alias+Geometry.swift
//  Types
//
//  Created by Mateusz Stompór on 14/10/2021.
//

import Metal

public typealias RamGeometry = Geometry<Data, IndexBitDepth, PrimitiveType>
public typealias GPUGeometry = Geometry<MTLBuffer, MTLIndexType, MTLPrimitiveType>
