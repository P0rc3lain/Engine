//
//  Copyright © 2021 Mateusz Stompór. All rights reserved.
//

import MetalBinding

public struct PNIOmniLightNode: PNOmniLightNode {
    public var light: PNOmniLight
    public var transform: PNTransform
    public init(light: PNOmniLight, transform: PNTransform) {
        self.light = light
        self.transform = transform
    }
    public func write(scene: PNSceneDescription, parentIdx: PNIndex) -> PNIndex {
        let entity = PNEntity(type: .omniLight, referenceIdx: scene.omniLights.count)
        scene.entities.add(parentIdx: parentIdx, data: entity)
        scene.skeletonReferences.append(.nil)
        let underlyingLight = OmniLight.make(color: light.color,
                                             intensity: light.intensity,
                                             index: scene.entities.count - 1)
        scene.omniLights.append(underlyingLight)
        return scene.entities.count - 1
    }
}
