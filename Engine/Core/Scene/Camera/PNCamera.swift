//
//  Copyright © 2022 Mateusz Stompór. All rights reserved.
//

import simd

/// A general interface that camera class must implement to allow rendering from the its perspective.
/// A player's vantage point in a game, eye into the world.
public protocol PNCamera {
    var projection: PNMatrix4x4FI { get }
    var boundingBox: PNBoundingBox { get }
}
