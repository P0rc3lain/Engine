//
//  Copyright © 2021 Mateusz Stompór. All rights reserved.
//

public struct PNIAnimatedNode: PNAnimatedNode {
    public var animator: PNAnimator
    public var animation: PNAnimatedCoordinateSpace
    public var transform: PNTransform {
        animator.transform(coordinateSpace: animation)
    }
    public init(animator: PNAnimator, animation: PNAnimatedCoordinateSpace) {
        self.animator = animator
        self.animation = animation
    }
    public func write(scene: inout PNSceneDescription, parentIdx: PNIndex) -> PNIndex {
        let entity = PNEntity(type: .group,
                              referenceIdx: .nil)
        scene.entities.add(parentIdx: parentIdx, data: entity)
        scene.skeletonReferences.append(.nil)
        return scene.entities.count - 1
    }
}
