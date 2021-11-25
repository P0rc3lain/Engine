//
//  Copyright © 2021 Mateusz Stompór. All rights reserved.
//

public protocol PNRenderingCoordinatorFactory {
    func new(drawableSize: CGSize) -> PNRenderingCoordinator?
}
