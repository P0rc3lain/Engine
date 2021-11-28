//
//  Copyright © 2021 Mateusz Stompór. All rights reserved.
//

protocol PNAnimatedNode: PNSceneNode {
    var animator: PNAnimator { get }
    var animation: PNAnimatedCoordinateSpace { get }
}
