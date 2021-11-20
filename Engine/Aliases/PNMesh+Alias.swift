//
//  Copyright © 2021 Mateusz Stompór. All rights reserved.
//

import Metal

public typealias PNRamMesh = PNMesh<Data, PNIndexBitDepth, PNPrimitiveType>
public typealias PNGPUMesh = PNMesh<MTLBuffer, MTLIndexType, MTLPrimitiveType>
