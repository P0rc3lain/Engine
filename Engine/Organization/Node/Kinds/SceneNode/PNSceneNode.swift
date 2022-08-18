//
//  Copyright © 2021 Mateusz Stompór. All rights reserved.
//

public protocol PNSceneNode: AnyObject {
    // Properties
    var transform: PNSubject<PNLTransform> { get }
    var worldTransform: PNSubject<PNM2WTransform> { get }
    var enclosingNode: PNScenePieceSubject { get }
    var modelUniforms: PNSubject<WModelUniforms> { get }
    // Optional as in some cases a node has
    // no size, e. g. leaf group node
    var boundingBox: PNSubject<PNBoundingBox?> { get }
    // Methods
    func update()
    func write(scene: PNSceneDescription, parentIdx: PNParentIndex) -> PNNewlyWrittenIndex
}
