//
//  SceneDescription.swift
//  Types
//
//  Created by Mateusz Stompór on 14/10/2021.
//

import Metal

public typealias RamSceneDescription = SceneDescription<Data, IndexBitDepth, PrimitiveType, Texture>
public typealias GPUSceneDescription = SceneDescription<MTLBuffer, MTLIndexType, MTLPrimitiveType, MTLTexture>
