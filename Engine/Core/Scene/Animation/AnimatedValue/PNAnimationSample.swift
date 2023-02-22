//
//  Copyright © 2021 Mateusz Stompór. All rights reserved.
//

/// Sample taken from ``PNKeyframeAnimation``.
public struct PNAnimationSample<T> {
    public let currentKeyFrame: T
    public let upcomingKeyFrame: T
    public let ratio: PNRadians
}
