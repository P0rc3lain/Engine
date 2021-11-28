//
//  Copyright © 2021 Mateusz Stompór. All rights reserved.
//

public protocol PNSceneNode {
    var transform: PNTransform { get }
    func write(scene: inout PNSceneDescription, parentIdx: PNIndex) -> PNIndex
}
