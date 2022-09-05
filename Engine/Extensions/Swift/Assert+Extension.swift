//
//  Copyright © 2022 Mateusz Stompór. All rights reserved.
//

import simd

public func assert(value: Float,
                   expected: Float,
                   allowedError: Float = 0,
                   message: String = "",
                   file: StaticString = #file,
                   line: UInt = #line) {
    assertInBound(value: value,
                  min: value - allowedError,
                  max: value + allowedError,
                  message: message,
                  file: file,
                  line: line)
}

public func assertZeroOne(_ value: Float,
                          allowedError: Float = 0,
                          message: String = "",
                          file: StaticString = #file,
                          line: UInt = #line) {
    assertInBound(value: value,
                  min: 0,
                  max: 1,
                  message: message,
                  file: file,
                  line: line)
}

public func assertUnit(vector: simd_float3,
                       message: String = "Must be a unit vector",
                       allowedError: Float = 0,
                       file: StaticString = #file,
                       line: UInt = #line) {
    assert(value: vector.norm,
           expected: 1,
           allowedError: allowedError,
           message: message,
           file: file,
           line: line)
}

public func assertInBound(value: Float,
                          min: Float,
                          max: Float,
                          message: String = "Value out of bounds",
                          file: StaticString = #file,
                          line: UInt = #line) {
    assert(value >= min, message, file: file, line: line)
    assert(value <= max, message, file: file, line: line)
}

public func assertValid(color: PNColor4,
                        message: String = "Each color component must be in [0, 1] range",
                        accuracy: Float = 0.001,
                        file: StaticString = #file,
                        line: UInt = #line) {
    assertValid(color: color.xyz, message: message, file: file, line: line)
    assertZeroOne(color.w, message: message, file: file, line: line)
}

public func assertValid(color: PNColor3,
                        message: String = "Each color component must be in [0, 1] range",
                        accuracy: Float = 0.001,
                        file: StaticString = #file,
                        line: UInt = #line) {
    assertZeroOne(color.x, message: message, file: file, line: line)
    assertZeroOne(color.y, message: message, file: file, line: line)
    assertZeroOne(color.z, message: message, file: file, line: line)
}
