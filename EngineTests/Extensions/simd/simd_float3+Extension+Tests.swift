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
    func testRandomPerpendicular() throws {
        let baseVector: simd_float3 = .one
        let perpendicular = baseVector.randomPerpendicular()
        XCTAssertEqual(dot(baseVector, perpendicular), .zero)
        XCTAssertNotEqual(perpendicular, .zero)
    }
    func testRandomPerpendicularDifferentLength() throws {
        let baseVector: simd_float3 = [0, 1, 0]
        let perpendicular = baseVector.randomPerpendicular(length: 2)
        XCTAssertEqual(dot(baseVector, perpendicular), .zero)
        XCTAssertEqual(perpendicular.norm, 2)
        XCTAssertNotEqual(perpendicular, .zero)
    }
}
