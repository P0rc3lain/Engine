//
//  Copyright © 2021 Mateusz Stompór. All rights reserved.
//

public protocol PNSceneNode {
    var transform: PNAnimatedCoordinateSpace { get }
    func write(scene: inout PNSceneDescription, parentIdx: PNIndex) -> PNIndex
}
