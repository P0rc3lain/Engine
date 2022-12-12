//
//  Copyright © 2022 Mateusz Stompór. All rights reserved.
//

import simd

func assert(value: Float,
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

func assertZeroOne(_ value: Float,
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

func assertUnit(vector: simd_float3,
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

func assertInBound<T: Comparable>(value: T,
                                  min: T,
                                  max: T,
                                  message: String = "Value out of bounds",
                                  file: StaticString = #file,
                                  line: UInt = #line) {
    assert(value >= min, message, file: file, line: line)
    assert(value <= max, message, file: file, line: line)
}

func assertValid(color: PNColor4,
                 message: String = "Each color component must be in [0, 1] range",
                 accuracy: Float = 0.001,
                 file: StaticString = #file,
                 line: UInt = #line) {
    assertValid(color: color.xyz, message: message, file: file, line: line)
    assertZeroOne(color.w, message: message, file: file, line: line)
}

func assertValid(color: PNColor3,
                 message: String = "Each color component must be in [0, 1] range",
                 accuracy: Float = 0.001,
                 file: StaticString = #file,
                 line: UInt = #line) {
    assertZeroOne(color.x, message: message, file: file, line: line)
    assertZeroOne(color.y, message: message, file: file, line: line)
    assertZeroOne(color.z, message: message, file: file, line: line)
}

func assertNil<T>(_ value: T?,
                  _ message: String = "Value must be nil",
                  file: StaticString = #file,
                  line: UInt = #line) {
    assert(value == nil, message, file: file, line: line)
}

func assertSorted<T: Comparable>(_ values: [T],
                                 _ message: String = "Collection must be sorted",
                                 file: StaticString = #file,
                                 line: UInt = #line) {
    assert(values == values.sorted(), message, file: file, line: line)
}

func assertNotEmpty<T>(_ values: [T],
                       _ message: String = "Collection must not be empty",
                       file: StaticString = #file,
                       line: UInt = #line) {
    assert(!values.isEmpty, message, file: file, line: line)
}

func assertGreaterOrEqual<T: Comparable>(_ v1: T,
                                         _ v2: T,
                                         _ message: String = "First parameter must be greater or equal to the second",
                                         file: StaticString = #file,
                                         line: UInt = #line) {
    assert(v1 >= v2, message, file: file, line: line)
}

func assertEqual<T: Comparable>(_ v1: T,
                                _ v2: T,
                                _ message: String = "First parameter must be equal to the second",
                                file: StaticString = #file,
                                line: UInt = #line) {
    assert(v1 == v2, message, file: file, line: line)
}

func assertAll(_ conditions: Bool...,
               message: String = "Conditions not meet",
               file: StaticString = #file,
               line: UInt = #line) {
    for condition in conditions {
        assert(condition, message, file: file, line: line)
    }
}
