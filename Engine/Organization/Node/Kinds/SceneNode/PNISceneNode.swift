//
//  Copyright © 2021 Mateusz Stompór. All rights reserved.
//

public final class PNISceneNode: PNSceneNode {
    public var transform: PNTransform
    public init(transform: PNTransform) {
        self.transform = transform
    }
    public func write(scene: PNSceneDescription, parentIdx: PNIndex) -> PNIndex {
        let entity = PNEntity(type: .group,
                              referenceIdx: .nil)
        scene.entities.add(parentIdx: parentIdx, data: entity)
        return scene.entities.count - 1
    }
}
