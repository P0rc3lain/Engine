//
//  Copyright © 2021 Mateusz Stompór. All rights reserved.
//

public final class PNISceneNode: PNSceneNode {
    public var transform: PNSubject<PNLTransform>
    public init(transform: PNLTransform) {
        self.transform = PNSubject(transform)
    }
    public func write(scene: PNSceneDescription, parentIdx: PNParentIndex) -> PNNewlyWrittenIndex {
        let entity = PNEntity(type: .group,
                              referenceIdx: .nil)
        scene.entities.add(parentIdx: parentIdx, data: entity)
        return scene.entities.count - 1
    }
    public func update() {
        // Empty
    }
}
