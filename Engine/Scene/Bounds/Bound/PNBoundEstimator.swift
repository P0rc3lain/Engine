//
//  Copyright © 2022 Mateusz Stompór. All rights reserved.
//

import MetalBinding

public protocol PNBoundEstimator {
    func bound(vertexBuffer: UnsafeRawBufferPointer) -> PNBound
    func bound(vertexBuffer: Data) -> PNBound
    func bound(vertexBuffer: [Vertex]) -> PNBound
}
