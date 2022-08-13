//
//  Copyright © 2021 Mateusz Stompór. All rights reserved.
//

import MetalBinding

public final class PNIOmniLightNode: PNOmniLightNode {
    public var light: PNOmniLight
    public var transform: PNTransform
    public init(light: PNOmniLight, transform: PNTransform) {
        self.light = light
        self.transform = transform
    }
    public func write(scene: PNSceneDescription, parentIdx: PNParentIndex) -> PNNewlyWrittenIndex {
        let entity = PNEntity(type: .omniLight, referenceIdx: scene.omniLights.count)
        scene.entities.add(parentIdx: parentIdx, data: entity)
        let underlyingLight = OmniLight.make(color: light.color,
                                             intensity: light.intensity,
                                             castsShadows: light.castsShadows,
                                             index: scene.entities.count - 1)
        scene.omniLights.append(underlyingLight)
        return scene.entities.count - 1
    }
}
