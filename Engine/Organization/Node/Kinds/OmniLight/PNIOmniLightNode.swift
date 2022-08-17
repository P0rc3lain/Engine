//
//  Copyright © 2021 Mateusz Stompór. All rights reserved.
//

import MetalBinding

public final class PNIOmniLightNode: PNOmniLightNode {
    public var light: PNOmniLight
    public let transform: PNSubject<PNLTransform>
    public let enclosingNode: PNScenePieceSubject
    public init(light: PNOmniLight,
                transform: PNLTransform) {
        self.light = light
        self.transform = PNSubject(transform)
        self.enclosingNode = PNSubject(PNWeakRef(nil))
    }
    public func write(scene: PNSceneDescription, parentIdx: PNParentIndex) -> PNNewlyWrittenIndex {
        let entity = PNEntity(type: .omniLight,
                              referenceIdx: scene.omniLights.count)
        scene.entities.add(parentIdx: parentIdx, data: entity)
        scene.omniLights.append(OmniLight.make(light: light,
                                               index: scene.entities.count - 1))
        return scene.entities.count - 1
    }
    public func update() {
        // Empty
    }
}
