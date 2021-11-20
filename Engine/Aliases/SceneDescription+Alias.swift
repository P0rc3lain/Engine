//
//  Copyright © 2021 Mateusz Stompór. All rights reserved.
//

import Metal
import ModelIO

public typealias RamSceneDescription = SceneDescription<Data, PNIndexBitDepth, PNPrimitiveType, MDLTexture>
public typealias GPUSceneDescription = SceneDescription<MTLBuffer, MTLIndexType, MTLPrimitiveType, MTLTexture>
