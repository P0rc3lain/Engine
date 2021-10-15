//
//  Alias+PieceDescription.swift
//  Types
//
//  Created by Mateusz Stompór on 14/10/2021.
//

import Metal

public typealias RamPieceDescription = PieceDescription<Data, IndexBitDepth, PrimitiveType>
public typealias GPUPieceDescription = PieceDescription<MTLBuffer, MTLIndexType, MTLPrimitiveType>
