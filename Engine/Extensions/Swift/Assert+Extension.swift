//
//  Copyright © 2022 Mateusz Stompór. All rights reserved.
//

public func assert(value: Float,
                   expected: Float,
                   accuracy: Float,
                   message: String = "",
                   file: StaticString = #file,
                   line: UInt = #line) {
    assert(value > expected - accuracy, message, file: file, line: line)
    assert(value < expected + accuracy, message, file: file, line: line)
}
