//
//  Copyright © 2021 Mateusz Stompór. All rights reserved.
//

import MetalBinding

public final class PNIAmbientLightNode: PNAmbientLightNode {
    public var light: PNAmbientLight
    public var transform: PNTransform
    public init(light: PNAmbientLight, transform: PNTransform) {
        self.light = light
        self.transform = transform
    }
    public func write(scene: PNSceneDescription, parentIdx: PNParentIndex) -> PNNewlyWrittenIndex {
        let entity = PNEntity(type: .ambientLight,
                              referenceIdx: scene.ambientLights.count)
        scene.entities.add(parentIdx: parentIdx, data: entity)
        let underlyinglight = AmbientLight(diameter: light.diameter,
                                           color: light.color,
                                           intensity: light.intensity,
                                           idx: Int32(scene.entities.count - 1))
        scene.ambientLights.append(underlyinglight)
        return scene.entities.count - 1
    }
}
