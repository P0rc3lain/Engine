//
//  Copyright © 2022 Mateusz Stompór. All rights reserved.
//

import simd
import XCTest

func XCTAssertEqual(_ expression1: SIMD3<Float>,
                    _ expression2: SIMD3<Float>,
                    accuracy: Float,
                    _ message: String = "",
                    file: StaticString = #filePath,
                    line: UInt = #line) throws {
    for i in 0 ..< 3 {
        XCTAssertEqual(expression1[i],
                       expression2[i],
                       accuracy: accuracy,
                       message,
                       file: file,
                       line: line)
    }
}

func XCTAssertEqual(_ expression1: SIMD4<Float>,
                    _ expression2: SIMD4<Float>,
                    accuracy: Float,
                    _ message: String = "",
                    file: StaticString = #filePath,
                    line: UInt = #line) {
    for i in 0 ..< 4 {
        XCTAssertEqual(expression1[i],
                       expression2[i],
                       accuracy: accuracy,
                       message,
                       file: file,
                       line: line)
    }
}
