//
//  Copyright © 2021 Mateusz Stompór. All rights reserved.
//

/// A concrete implementation of the PNChronometer protocol.
/// This struct manages time measurement, allowing it to be paused and resumed.
/// 
/// #### Paused
/// ```
/// startTime == pausedTime
/// ```
/// #### Running
/// ```
/// startTime != nil
/// pauseTime == nil
/// ```
/// #### Invalid State
/// ```
/// startTime == nil
/// pauseTime != nil
/// ```
/// #### Invalid State
/// ```
/// startTime == nil
/// pauseTime == nil
/// ```
public struct PNIChronometer: PNChronometer {
    /// The start time of the chronometer.
    private var startTime: Date

    /// The time when the chronometer was last paused.
    private var pauseTime: Date

    /// A closure that produces the current date and time.
    private var timeProducer: () -> Date

    /// Accumulated time when the chronometer is paused.
    private var timeAccumulator: TimeInterval

    /// The total elapsed time measured by the chronometer.
    /// 
    /// If the chronometer is paused, this property returns the time elapsed between the start time and the pause time, 
    /// plus any accumulated time from previous pauses. If the chronometer is running, this property returns the time 
    /// elapsed between the start time and the current time, plus any accumulated time from previous pauses.
    public var elapsedTime: TimeInterval {
        if isPaused {
            return pauseTime.timeIntervalSince(startTime) + timeAccumulator
        } else {
            return timeProducer().timeIntervalSince(startTime) + timeAccumulator
        }
    }

    /// Indicates whether the chronometer is currently paused.
    public var isPaused: Bool {
        pauseTime != .nil
    }

    /// Creates a running instance of PNIChronometer.
    /// 
    /// The chronometer starts measuring time immediately, and its initial state is running.
    static var running: PNIChronometer {
        PNIChronometer(paused: false) {
            Date()
        }
    }

    /// Creates a paused instance of PNIChronometer.
    /// 
    /// The chronometer starts in a paused state, and its initial elapsed time is zero.
    static var paused: PNIChronometer {
        PNIChronometer(paused: true) {
            Date()
        }
    }

    /// Initializes a new instance of PNIChronometer.
    /// 
    /// - Parameters:
    ///   - paused: A Boolean value indicating whether the chronometer should start paused. Defaults to false.
    ///   - producer: A closure that produces the current date and time.
    public init(paused: Bool = false,
                timeProducer producer: @escaping () -> Date) {
        let date = producer()
        timeAccumulator = 0
        startTime = date
        pauseTime = paused ? date : Date.nil
        timeProducer = producer
    }

    /// Pauses the chronometer.
    /// 
    /// If the chronometer is already paused, this method has no effect.
    public mutating func pause() {
        if !isPaused {
            pauseTime = timeProducer()
        }
    }

    /// Toggles the chronometer's state between paused and running.
    /// 
    /// If the chronometer is paused, this method resumes it. If the chronometer is running, this method pauses it.
    public mutating func toggle() {
        if isPaused {
            resume()
        } else {
            pause()
        }
    }

    /// Resumes the chronometer.
    /// 
    /// If the chronometer is already running, this method has no effect.
    public mutating func resume() {
        if isPaused {
            timeAccumulator += pauseTime.timeIntervalSince(startTime)
            pauseTime = .nil
            startTime = timeProducer()
        }
    }

    /// Resets the chronometer to its initial state.
    /// 
    /// The chronometer's elapsed time is reset to zero, and its state is set to the initial state (paused or running).
    public mutating func reset() {
        timeAccumulator = 0
        let currentTime = timeProducer()
        startTime = currentTime
        pauseTime = isPaused ? currentTime : .nil
    }
}
