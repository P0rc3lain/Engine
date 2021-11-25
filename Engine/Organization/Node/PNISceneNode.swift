//
//  Copyright © 2021 Mateusz Stompór. All rights reserved.
//

struct PNISceneNode: PNSceneNode {
    var transform: PNAnimatedCoordinateSpace
    func write(scene: inout PNSceneDescription, parentIdx: PNIndex) -> PNIndex {
        let entity = PNEntity(type: .group,
                              referenceIdx: .nil)
        scene.entities.add(parentIdx: parentIdx, data: entity)
        scene.skeletonReferences.append(.nil)
        return scene.entities.count - 1
    }
}
