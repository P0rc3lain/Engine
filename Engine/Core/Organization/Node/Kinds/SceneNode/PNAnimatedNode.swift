//
//  Copyright © 2021 Mateusz Stompór. All rights reserved.
//

/// Node which has movement described in form of keyframe animation sequence.
public protocol PNAnimatedNode: PNSceneNode {
    var animator: PNAnimator { get set }
    var animation: PNAnimatedCoordinateSpace { get set }
}
