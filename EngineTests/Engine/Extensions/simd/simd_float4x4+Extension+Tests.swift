//
//  Copyright © 2021 Mateusz Stompór. All rights reserved.
//

@testable import Engine
import simd
import XCTest

class SimdFloat4x4Tests: XCTestCase {
    let projectionMatrix = float4x4.orthographicProjection(left: 10,
                                                           right: 20,
                                                           top: 40,
                                                           bottom: 30,
                                                           near: 60,
                                                           far: 50)
    func testOrthographicProjection() throws {
        XCTAssertEqual(projectionMatrix.inverse * [-1, -1, 0, 1], [10, 30, -60, 1], accuracy: 0.001)
        XCTAssertEqual(projectionMatrix.inverse * [1, -1, 0, 1], [20, 30, -60, 1], accuracy: 0.001)
        XCTAssertEqual(projectionMatrix.inverse * [-1, 1, 0, 1], [10, 40, -60, 1], accuracy: 0.001)
        XCTAssertEqual(projectionMatrix.inverse * [1, 1, 0, 1], [20, 40, -60, 1], accuracy: 0.001)
        XCTAssertEqual(projectionMatrix.inverse * [1, 1, 1, 1], [20, 40, -50, 1], accuracy: 0.001)
    }
}
