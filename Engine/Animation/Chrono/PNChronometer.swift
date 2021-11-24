//
//  Copyright © 2021 Mateusz Stompór. All rights reserved.
//

protocol PNChronometer {
    var isPaused: Bool { get }
    var elapsedTime: TimeInterval { get }
    mutating func pause()
    mutating func resume()
    mutating func reset()
}
