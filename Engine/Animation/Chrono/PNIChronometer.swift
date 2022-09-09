//
//  Copyright © 2021 Mateusz Stompór. All rights reserved.
//

// Paused
// startTime == pausedTime

// Running
// startTime != nil
// pauseTime = nil

// Invalid State
// startTime = nil
// pauseTime != nil

// Invalid State
// startTime = nil
// pauseTime = nil

public struct PNIChronometer: PNChronometer {
    private var startTime: Date
    private var pauseTime: Date
    private var timeProducer: () -> Date
    private var timeAccumulator: TimeInterval
    public var elapsedTime: TimeInterval {
        if isPaused {
            return pauseTime.timeIntervalSince(startTime) + timeAccumulator
        } else {
            return timeProducer().timeIntervalSince(startTime) + timeAccumulator
        }
    }
    public var isPaused: Bool {
        pauseTime != .nil
    }
    static var running: PNIChronometer {
        PNIChronometer(paused: false) {
            Date()
        }
    }
    static var paused: PNIChronometer {
        PNIChronometer(paused: true) {
            Date()
        }
    }
    public init(paused: Bool = false,
                timeProducer producer: @escaping () -> Date) {
        let date = producer()
        timeAccumulator = 0
        startTime = date
        pauseTime = paused ? date : Date.nil
        timeProducer = producer
    }
    public mutating func pause() {
        if !isPaused {
            pauseTime = timeProducer()
        }
    }
    public mutating func toggle() {
        if isPaused {
            resume()
        } else {
            pause()
        }
    }
    public mutating func resume() {
        if isPaused {
            timeAccumulator += pauseTime.timeIntervalSince(startTime)
            pauseTime = .nil
            startTime = timeProducer()
        }
    }
    public mutating func reset() {
        timeAccumulator = 0
        let currentTime = timeProducer()
        startTime = currentTime
        pauseTime = isPaused ? currentTime : .nil
    }
}
