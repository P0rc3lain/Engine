//
//  Copyright © 2021 Mateusz Stompór. All rights reserved.
//

/// Sample taken from ``PNKeyframeAnimation``.
/// Represents a sample in a keyframe animation sequence used for interpolation.
///
/// This struct holds information about two consecutive keyframes and their
/// interpolation ratio. It is used to calculate intermediate values between
/// keyframes during animation playback. The generic type `T` matches the type
/// of the keyframes in the source ``PNKeyframeAnimation``.
public struct PNAnimationSample<T> {
    /// The current keyframe in the animation sequence.
    /// This represents the starting point for interpolation.
    public let currentKeyFrame: T
    /// The next keyframe in the animation sequence.
    /// This represents the target point for interpolation.
    public let upcomingKeyFrame: T
    /// The interpolation ratio between the current and upcoming keyframes.
    /// A value between 0 and 1, where 0 represents currentKeyFrame and 1 represents upcomingKeyFrame.
    public let ratio: PNRatio
}
