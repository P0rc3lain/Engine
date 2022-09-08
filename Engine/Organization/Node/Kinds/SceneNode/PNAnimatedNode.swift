//
//  Copyright © 2021 Mateusz Stompór. All rights reserved.
//

public protocol PNAnimatedNode: PNSceneNode {
    var animator: PNAnimator { get }
    var animation: PNAnimatedCoordinateSpace { get set }
}
