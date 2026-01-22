//
//  Copyright © 2021 Mateusz Stompór. All rights reserved.
//

import PNShared

/// Interface used to describe a minimal scene node.
/// In hierarchical structure embedded in ``PNNode``, when it is used as ``PNScenePiece``.
public protocol PNSceneNode: AnyObject {
    var name: String { get }
    var transform: PNLTransform { get set }
    var worldTransform: PNM2WTransform { get set }
    var enclosingNode: PNScenePiece? { get set }
    var modelUniforms: PNWModelUniforms { get set }
    var localBoundingBox: PNBoundingBox? { get set }
    var worldBoundingBox: PNBoundingBox? { get set }
    var childrenMergedBoundingBox: PNBoundingBox? { get set }
    var intrinsicBoundingBox: PNBoundingBox? { get }
    func update()
    func write(scene: PNSceneDescription, parentIdx: PNParentIndex) -> PNNewlyWrittenIndex
}
