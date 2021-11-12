//
//  Copyright © 2021 Mateusz Stompór. All rights reserved.
//

@testable import Engine
import simd
import XCTest

class BoundingBoxTests: XCTestCase {
    let bounds = Bound(min: [-1, -2, -3], max: [4, 5, 6])
    func testTransformations() throws {
        let boundingBox = BoundingBox.from(bound: bounds)
        let result = simd_float4x4.scale([2, 3, 4]) * boundingBox
        XCTAssertEqual(result.corners[0], [-2, -6, -12])
        XCTAssertEqual(result.corners[1], [8, -6, -12])
        XCTAssertEqual(result.corners[2], [-2, -6, 24])
        XCTAssertEqual(result.corners[3], [8, -6, 24])
        XCTAssertEqual(result.corners[4], [-2, 15, -12])
        XCTAssertEqual(result.corners[5], [8, 15, -12])
        XCTAssertEqual(result.corners[6], [-2, 15, 24])
        XCTAssertEqual(result.corners[7], [8, 15, 24])
    }
    func testCreationFromBounds() throws {
        let boundingBox = BoundingBox.from(bound: bounds)
        XCTAssertEqual(boundingBox.corners[0], [-1, -2, -3])
        XCTAssertEqual(boundingBox.corners[1], [4, -2, -3])
        XCTAssertEqual(boundingBox.corners[2], [-1, -2, 6])
        XCTAssertEqual(boundingBox.corners[3], [4, -2, 6])
        XCTAssertEqual(boundingBox.corners[4], [-1, 5, -3])
        XCTAssertEqual(boundingBox.corners[5], [4, 5, -3])
        XCTAssertEqual(boundingBox.corners[6], [-1, 5, 6])
        XCTAssertEqual(boundingBox.corners[7], [4, 5, 6])
    }
    func testBound() throws {
        let boundingBox = BoundingBox.from(bound: bounds)
        let retrievedBounx = boundingBox.bound
        XCTAssertEqual(bounds.min, retrievedBounx.min)
        XCTAssertEqual(bounds.max, retrievedBounx.max)
    }
    func testAABB() throws {
        let boundingBox = BoundingBox.from(bound: bounds)
        let aaBoundingBox = boundingBox.aabb.corners
        XCTAssertEqual(boundingBox.corners, aaBoundingBox)
    }
}
