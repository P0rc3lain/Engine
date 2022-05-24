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
    public func write(scene: PNSceneDescription, parentIdx: PNIndex) -> PNIndex {
        let entity = PNEntity(type: .spotLight, referenceIdx: scene.spotLights.count)
        scene.entities.add(parentIdx: parentIdx, data: entity)
        let underlyingLight = SpotLight.make(color: light.color,
                                             intensity: light.intensity,
                                             coneAngle: light.coneAngle,
                                             index: scene.entities.count - 1)
        scene.spotLights.append(underlyingLight)
        return scene.entities.count - 1
    }
}
