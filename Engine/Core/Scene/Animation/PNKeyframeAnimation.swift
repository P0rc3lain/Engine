//
//  Copyright © 2022 Mateusz Stompór. All rights reserved.
//

/// This struct defines keyframes and their corresponding time points
/// for interpolation in an animation sequence. The generic type `T`
/// represents the type of value being animated (e.g., position, color, etc.).
public struct PNKeyframeAnimation<T> {
    /// An array of keyframes that define the main points in the animation sequence.
    /// Each keyframe represents a specific state of type `T` at a given time point.
    public var keyFrames: [T]
    /// An array of time points corresponding to each keyframe.
    /// Must be sorted in ascending order and have the same count as `keyFrames`.
    public let times: [PNTimePoint]
    /// The maximum time for the animation sequence.
    /// Must be greater than or equal to the last time point.
    public let maximumTime: PNTimePoint
    /// Initializes a keyframe animation with keyframes, times, and maximum time.
    /// - Parameters:
    ///   - keyFrames: Array of animation keyframes of type `T`
    ///   - times: Array of time points for each keyframe
    ///   - maximumTime: The maximum time point for the animation
    /// - Precondition: `times` array must not be empty
    /// - Precondition: `times` array must be sorted in ascending order
    /// - Precondition: `times.count` must equal `keyFrames.count`
    /// - Precondition: `maximumTime` must be greater than or equal to the last time point
    public init(keyFrames: [T],
                times: [PNTimePoint],
                maximumTime: PNTimePoint) {
        assertEqual(times.count, keyFrames.count)
        assertSorted(times)
        assertNotEmpty(times)
        assertGreaterOrEqual(maximumTime, times[times.count - 1])
        self.keyFrames = keyFrames
        self.times = times
        self.maximumTime = maximumTime
    }
    /// Creates a static animation with a single keyframe.
    /// - Parameter value: The value for the static keyframe
    /// - Returns: A PNKeyframeAnimation with a single keyframe at time 0 and maximum time 1
    static public func `static`(from value: T) -> PNKeyframeAnimation<T> {
        PNKeyframeAnimation<T>(keyFrames: [value],
                               times: [0],
                               maximumTime: 1)
    }
}
