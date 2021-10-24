//
//  Copyright © 2021 Mateusz Stompór. All rights reserved.
//

import Metal

public typealias RamIndexBasedDraw = IndexBasedDraw<Data, IndexBitDepth, PrimitiveType>
public typealias GPUIndexBasedDraw = IndexBasedDraw<MTLBuffer, MTLIndexType, MTLPrimitiveType>
