//
//  Copyright © 2021 Mateusz Stompór. All rights reserved.
//

public protocol PNSceneNode: AnyObject {
    var name: String { get }
    var transform: PNSubject<PNLTransform> { get }
    var worldTransform: PNSubject<PNM2WTransform> { get }
    var enclosingNode: PNScenePieceSubject { get }
    var modelUniforms: PNSubject<PNWModelUniforms> { get }
    var localBoundingBox: PNSubject<PNBoundingBox?> { get }
    var worldBoundingBox: PNSubject<PNBoundingBox?> { get }
    var childrenMergedBoundingBox: PNSubject<PNBoundingBox?> { get }
    var intrinsicBoundingBox: PNBoundingBox? { get }
    func update()
    func write(scene: PNSceneDescription, parentIdx: PNParentIndex) -> PNNewlyWrittenIndex
}
