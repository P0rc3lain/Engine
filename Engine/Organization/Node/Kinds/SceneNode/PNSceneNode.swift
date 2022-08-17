//
//  Copyright © 2021 Mateusz Stompór. All rights reserved.
//

public protocol PNSceneNode: AnyObject {
    var transform: PNSubject<PNLTransform> { get }
    var enclosingNode: PNScenePieceSubject { get }
    func update()
    func write(scene: PNSceneDescription, parentIdx: PNParentIndex) -> PNNewlyWrittenIndex
}
