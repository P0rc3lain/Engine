//
//  Copyright © 2021 Mateusz Stompór. All rights reserved.
//

import Metal

public typealias RamPieceDescription = PieceDescription<Data, IndexBitDepth, PrimitiveType>
public typealias GPUPieceDescription = PieceDescription<MTLBuffer, MTLIndexType, MTLPrimitiveType>
