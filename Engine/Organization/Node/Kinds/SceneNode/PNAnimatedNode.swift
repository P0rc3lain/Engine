//
//  Copyright © 2021 Mateusz Stompór. All rights reserved.
//

public protocol PNAnimatedNode: PNSceneNode {
    var animator: PNAnimator { get set }
    var animation: PNAnimatedCoordinateSpace { get set }
}
