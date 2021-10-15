//
//  Alias+IndexBasedDraw.swift
//  Types
//
//  Created by Mateusz Stompór on 14/10/2021.
//

import Metal

public typealias RamIndexBasedDraw = IndexBasedDraw<Data, IndexBitDepth, PrimitiveType>
public typealias GPUIndexBasedDraw = IndexBasedDraw<MTLBuffer, MTLIndexType, MTLPrimitiveType>
