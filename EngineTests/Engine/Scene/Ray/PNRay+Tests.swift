//
//  Copyright © 2022 Mateusz Stompór. All rights reserved.
//

@testable import Engine
import simd
import XCTest

class PNRayTests: XCTestCase {
    func testTranslation() throws {
        let ray = PNRay(origin: .zero, direction: [0, 0, -1])
        let transform = simd_float4x4.translation(vector: [1, 0, 0])
        let transformed = transform * ray
        XCTAssertEqual(transformed.direction, [0, 0, -1])
        XCTAssertEqual(transformed.origin, [1, 0, 0])
    }
    func testRotation() throws {
        let ray = PNRay(origin: .zero, direction: [0, 0, -1])
        let transform = simd_quatf(angle: Float(90).radians, axis: [0, 1, 0]).rotationMatrix
        let transformed = transform * ray
        XCTAssertEqual(transformed.direction.x, -1, accuracy: 0.001)
        XCTAssertEqual(transformed.direction.y, 0, accuracy: 0.001)
        XCTAssertEqual(transformed.direction.z, 0, accuracy: 0.001)
        XCTAssertEqual(transformed.origin, [0, 0, 0])
    }
}
