//
//  Copyright © 2021 Mateusz Stompór. All rights reserved.
//

/// Supervises and manages the rendering process.
public protocol PNRenderingCoordinator {
    mutating func draw(frameSupply: PNFrameSupply)
}
