//
//  Copyright © 2021 Mateusz Stompór. All rights reserved.
//

import MetalKit

public struct PNIRenderingCoordinatorFactory: PNRenderingCoordinatorFactory {
    private let view: MTKView
    public init(view: MTKView) {
        self.view = view
    }
    public func new(drawableSize: CGSize) -> PNRenderingCoordinator? {
        PNIRenderingCoordinator(view: view, renderingSize: drawableSize)
    }
}
