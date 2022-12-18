//
//  Copyright © 2021 Mateusz Stompór. All rights reserved.
//

import CoreGraphics

public protocol PNRenderingCoordinatorFactory {
    func new(drawableSize: CGSize) -> PNRenderingCoordinator?
}
