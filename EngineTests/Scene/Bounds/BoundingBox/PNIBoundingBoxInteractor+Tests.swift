//
//  Copyright © 2021 Mateusz Stompór. All rights reserved.
//

@testable import Engine
import simd
import XCTest

class PNIBoundingBoxInteractorTests: XCTestCase {
    let interactor: PNBoundingBoxInteractor = PNIBoundingBoxInteractor.default
    let boundInteractor: PNBoundInteractor = PNIBoundInteractor()
    let bounds = PNBound(min: [-1, -2, -3], max: [4, 5, 6])
    func testTransformations() throws {
        let boundingBox = interactor.from(bound: bounds)
        let result = interactor.multiply(simd_float4x4.scale([2, 3, 4]), boundingBox)
        let corners = interactor.corners(result)
        XCTAssertEqual(corners[0], [-2, -6, -12])
        XCTAssertEqual(corners[1], [8, -6, -12])
        XCTAssertEqual(corners[2], [-2, -6, 24])
        XCTAssertEqual(corners[3], [8, -6, 24])
        XCTAssertEqual(corners[4], [-2, 15, -12])
        XCTAssertEqual(corners[5], [8, 15, -12])
        XCTAssertEqual(corners[6], [-2, 15, 24])
        XCTAssertEqual(corners[7], [8, 15, 24])
    }
    func testCreationFromBounds() throws {
        let boundingBox = interactor.from(bound: bounds)
        let corners = interactor.corners(boundingBox)
        XCTAssertEqual(corners[0], [-1, -2, -3])
        XCTAssertEqual(corners[1], [4, -2, -3])
        XCTAssertEqual(corners[2], [-1, -2, 6])
        XCTAssertEqual(corners[3], [4, -2, 6])
        XCTAssertEqual(corners[4], [-1, 5, -3])
        XCTAssertEqual(corners[5], [4, 5, -3])
        XCTAssertEqual(corners[6], [-1, 5, 6])
        XCTAssertEqual(corners[7], [4, 5, 6])
    }
    func testBound() throws {
        let boundingBox = interactor.from(bound: bounds)
        let retrievedBound = interactor.bound(boundingBox)
        XCTAssertEqual(bounds.min, retrievedBound.min)
        XCTAssertEqual(bounds.max, retrievedBound.max)
    }
    func testAABB() throws {
        let boundingBox = interactor.from(bound: bounds)
        let aaBoundingBox = interactor.aabb(boundingBox)
        XCTAssertEqual(interactor.corners(boundingBox),
                       interactor.corners(aaBoundingBox))
    }
    func testAABBFromOOBB() throws {
        let boundingBox = interactor.from([[0, 0, 0], [2, 0, 0], [0, 1, 3], [2, 1, 3],
                                           [0, 3, 0], [2, 3, 0], [0, 4, 3], [2, 4, 3]])
        let aabb = interactor.aabb(boundingBox)
        XCTAssertEqual(aabb.corners[0], [0, 0, 0])
        XCTAssertEqual(aabb.corners[1], [2, 0, 0])
        XCTAssertEqual(aabb.corners[2], [0, 0, 3])
        XCTAssertEqual(aabb.corners[3], [2, 0, 3])
        XCTAssertEqual(aabb.corners[4], [0, 4, 0])
        XCTAssertEqual(aabb.corners[5], [2, 4, 0])
        XCTAssertEqual(aabb.corners[6], [0, 4, 3])
        XCTAssertEqual(aabb.corners[7], [2, 4, 3])
    }
    func testMergeTheSameBox() throws {
        let minimalBound = boundInteractor.zero
        let boundingBox = interactor.from(bound: minimalBound)
        let box = interactor.merge(boundingBox, boundingBox)
        let corners = interactor.corners(box)
        for i in 8.naturalExclusive {
            XCTAssertEqual(corners[i], [0, 0, 0])
        }
    }
    func testMergeDisjointBoxes() throws {
        let boundA = PNBound(min: [0, 0, 0], max: [2, 2, 2])
        let boundB = PNBound(min: [-4, -4, -4], max: [-2, -2, -2])
        let merged = interactor.merge(interactor.from(bound: boundA),
                                      interactor.from(bound: boundB))
        XCTAssertTrue(boundInteractor.isEqual(interactor.bound(merged),
                                              PNBound(min: [-4, -4, -4], max: [2, 2, 2])))
    }
    func testMultiplication() throws {
        let bounds = PNBound(min: .zero, max: [2, 2, 2])
        let boundingBox = interactor.from(bound: bounds)
        let translated = interactor.multiply(simd_float4x4.translation(vector: [1, 2, 3]), boundingBox)
        let result = interactor.bound(translated)
        XCTAssertEqual(result.min, [1, 2, 3])
        XCTAssertEqual(result.max, [3, 4, 5])
    }
}
