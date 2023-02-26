//
//  Copyright © 2021 Mateusz Stompór. All rights reserved.
//

import CoreGraphics

/// Builds a new coordinator tailored for a new configuration.
public protocol PNRenderingCoordinatorFactory {
    func new(drawableSize: CGSize) -> PNRenderingCoordinator?
}
