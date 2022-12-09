//
//  Copyright © 2021 Mateusz Stompór. All rights reserved.
//

public protocol PNRenderMaskGenerator {
    func generate(scene: PNSceneDescription) -> PNRenderMask
}
