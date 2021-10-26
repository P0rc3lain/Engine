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

struct Chronometer {
    private var startTime: Date
    private var pauseTime: Date
    private var timeProducer: () -> Date
    private var timeAccumulator: TimeInterval
    var elapsedTime: TimeInterval {
        if isPaused {
            return pauseTime.timeIntervalSince(startTime) + timeAccumulator
        } else {
            return timeProducer().timeIntervalSince(startTime) + timeAccumulator
        }
    }
    var isPaused: Bool {
        pauseTime != .nil
    }
    static var running: Chronometer {
        Chronometer(paused: false) {
            Date()
        }
    }
    static var paused: Chronometer {
        Chronometer(paused: true) {
            Date()
        }
    }
    init(paused: Bool = false,
         timeProducer producer: @escaping () -> Date) {
        let date = producer()
        timeAccumulator = 0
        startTime = date
        pauseTime = paused ? date : Date.nil
        timeProducer = producer
    }
    mutating func pause() {
        if !isPaused {
            pauseTime = timeProducer()
        }
    }
    mutating func resume() {
        if isPaused {
            timeAccumulator += pauseTime.timeIntervalSince(startTime)
            pauseTime = .nil
            startTime = timeProducer()
        }
    }
    mutating func reset() {
        timeAccumulator = 0
        let currentTime = timeProducer()
        startTime = currentTime
        pauseTime = isPaused ? currentTime : .nil
    }
}
