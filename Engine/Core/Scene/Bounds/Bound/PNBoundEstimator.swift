//
//  Copyright © 2022 Mateusz Stompór. All rights reserved.
//

import PNShared

/// Calculates bound for an array of vertices
public protocol PNBoundEstimator {
    func bound(vertexBuffer: UnsafeRawBufferPointer) -> PNBound
    func bound(vertexBuffer: Data) -> PNBound
    func bound(vertexBuffer: [Vertex]) -> PNBound
}
