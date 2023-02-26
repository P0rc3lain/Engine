//
//  Copyright © 2021 Mateusz Stompór. All rights reserved.
//

/// Creates culling masks for each camera-like object which can be used for being a rendering perspective.
public protocol PNRenderMaskGenerator {
    func generate(scene: PNSceneDescription) -> PNRenderMask
}
