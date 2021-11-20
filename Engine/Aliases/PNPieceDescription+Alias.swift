//
//  Copyright © 2021 Mateusz Stompór. All rights reserved.
//

import Metal

public typealias PNRamPieceDescription = PNPieceDescription<Data, PNIndexBitDepth, PNPrimitiveType>
public typealias PNGPUPieceDescription = PNPieceDescription<MTLBuffer, MTLIndexType, MTLPrimitiveType>
