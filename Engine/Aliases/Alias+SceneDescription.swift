//
//  SceneDescription.swift
//  Engine
//
//  Created by Mateusz Stompór on 14/10/2021.
//

import Metal
import ModelIO

public typealias RamSceneDescription = SceneDescription<Data, IndexBitDepth, PrimitiveType, MDLTexture>
public typealias GPUSceneDescription = SceneDescription<MTLBuffer, MTLIndexType, MTLPrimitiveType, MTLTexture>
