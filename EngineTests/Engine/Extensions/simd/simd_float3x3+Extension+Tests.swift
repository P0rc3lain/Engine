//
//  Copyright © 2021 Mateusz Stompór. All rights reserved.
//

@testable import Engine
import simd
import XCTest

class SimdFloat3x3Tests: XCTestCase {
    func testExpand() throws {
        XCTAssertEqual(simd_float3x3.identity.expanded, .identity)
    }
    func testRotationMatrixFromDirection() throws {
        let basis = simd_float3x3.from(directionVector: [1, 0, 0])
        let x = basis.columns.0
        let y = basis.columns.1
        let z = basis.columns.2
        XCTAssertEqual(x.norm, 1, accuracy: 0.01)
        XCTAssertEqual(y.norm, 1, accuracy: 0.01)
        XCTAssertEqual(z.norm, 1, accuracy: 0.01)
        XCTAssertEqual(dot(x, y), 0, accuracy: 0.01)
        XCTAssertEqual(dot(x, z), 0, accuracy: 0.01)
        XCTAssertEqual(dot(y, z), 0, accuracy: 0.01)
    }
}
