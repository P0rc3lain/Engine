//
//  Copyright © 2022 Mateusz Stompór. All rights reserved.
//

public func assert(_ condition: @autoclosure () -> Float,
                   _ accuracy: @autoclosure () -> Float,
                   _ message: @autoclosure () -> String = String(),
                   file: StaticString = #file,
                   line: UInt = #line) {
    let number = condition()
    let allowedDifference = accuracy()
    let providedMessage = message()
    assert(number > number - allowedDifference, providedMessage, file: file, line: line)
    assert(number < number + allowedDifference, providedMessage, file: file, line: line)
}
