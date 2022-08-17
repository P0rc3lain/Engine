//
//  Copyright © 2021 Mateusz Stompór. All rights reserved.
//

public protocol PNSceneNode: AnyObject {
    var transform: PNSubject<PNLTransform> { get }
    var worldTransform: PNSubject<PNM2WTransform> { get }
    var enclosingNode: PNScenePieceSubject { get }
    var modelUniforms: PNSubject<WModelUniforms> { get }
    func update()
    func write(scene: PNSceneDescription, parentIdx: PNParentIndex) -> PNNewlyWrittenIndex
}
