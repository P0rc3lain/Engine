//
//  Copyright © 2021 Mateusz Stompór. All rights reserved.
//

import MetalBinding

public final class PNISpotLightNode: PNSpotLightNode {
    public var light: PNSpotLight
    public var transform: PNTransform
    public init(light: PNSpotLight, transform: PNTransform) {
        self.light = light
        self.transform = transform
    }
    public func write(scene: PNSceneDescription, parentIdx: PNParentIndex) -> PNNewlyWrittenIndex {
        let entity = PNEntity(type: .spotLight, referenceIdx: scene.spotLights.count)
        scene.entities.add(parentIdx: parentIdx, data: entity)
        scene.spotLights.append(SpotLight.make(light: light,
                                               index: scene.entities.count - 1))
        return scene.entities.count - 1
    }
}
