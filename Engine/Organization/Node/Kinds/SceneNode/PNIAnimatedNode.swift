//
//  Copyright © 2021 Mateusz Stompór. All rights reserved.
//

struct PNIAnimatedNode: PNAnimatedNode {
    var animator: PNAnimator
    var animation: PNAnimatedCoordinateSpace
    var transform: PNTransform {
        animator.transform(coordinateSpace: animation)
    }
    init(animator: PNAnimator, animation: PNAnimatedCoordinateSpace) {
        self.animator = animator
        self.animation = animation
    }
    func write(scene: inout PNSceneDescription, parentIdx: PNIndex) -> PNIndex {
        let entity = PNEntity(type: .group,
                              referenceIdx: .nil)
        scene.entities.add(parentIdx: parentIdx, data: entity)
        scene.skeletonReferences.append(.nil)
        return scene.entities.count - 1
    }
}
