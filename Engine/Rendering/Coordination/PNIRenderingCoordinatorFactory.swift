//
//  Copyright © 2021 Mateusz Stompór. All rights reserved.
//

import MetalKit

struct PNIRenderingCoordinatorFactory: PNRenderingCoordinatorFactory {
    private let view: MTKView
    init(view: MTKView) {
        self.view = view
    }
    func new(drawableSize: CGSize) -> PNRenderingCoordinator? {
        PNIRenderingCoordinator(view: view, renderingSize: drawableSize)
    }
}
