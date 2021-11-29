//
//  Copyright © 2021 Mateusz Stompór. All rights reserved.
//

@testable import Engine
import simd
import XCTest

class SimdFloat3Tests: XCTestCase {
    func testRandom() throws {
        let vector = simd_float3.random(in: 0 ..< 1)
        XCTAssertGreaterThanOrEqual(vector.x, 0)
        XCTAssertGreaterThanOrEqual(vector.y, 0)
        XCTAssertGreaterThanOrEqual(vector.z, 0)
        XCTAssertLessThan(vector.x, 1)
        XCTAssertLessThan(vector.y, 1)
        XCTAssertLessThan(vector.z, 1)
    }
    func testNormalized() throws {
        let vector = simd_float3(10, 20, 30)
        let normalized = vector.normalized
        XCTAssertEqual(1, normalized.norm, accuracy: 0.01)
    }
}
