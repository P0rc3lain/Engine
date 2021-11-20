//
//  Copyright © 2021 Mateusz Stompór. All rights reserved.
//

import Metal

public typealias PNRamSubmesh = PNSubmesh<Data, PNIndexBitDepth, PNPrimitiveType>
public typealias PNGPUSubmesh = PNSubmesh<MTLBuffer, MTLIndexType, MTLPrimitiveType>
