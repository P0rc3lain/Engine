//
//  Copyright © 2021 Mateusz Stompór. All rights reserved.
//

/// A protocol for objects that measure time and can be paused, resumed, and reset.
public protocol PNChronometer {
    /// Indicates whether the chronometer is currently paused.
    var isPaused: Bool { get }

    /// The total elapsed time measured by the chronometer.
    var elapsedTime: TimeInterval { get }

    /// Pauses the time measurement.
    mutating func pause()

    /// Resumes the time measurement if it was paused.
    mutating func resume()

    /// Toggles the pause state of the chronometer.
    mutating func toggle()

    /// Resets the elapsed time to zero.
    mutating func reset()
}
