//
//  Copyright © 2021 Mateusz Stompór. All rights reserved.
//

public protocol PNSceneNode: AnyObject {
    var transform: PNTransform { get }
    func write(scene: PNSceneDescription, parentIdx: PNIndex) -> PNIndex
}
