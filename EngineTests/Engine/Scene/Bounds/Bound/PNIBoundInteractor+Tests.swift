//
//  Copyright © 2022 Mateusz Stompór. All rights reserved.
//

@testable import Engine
import simd
import XCTest

class PNIRayIntersectionTests: XCTestCase {
    let interactor = PNIBoundInteractor()
    func testRayInBound() throws {
        XCTAssertTrue(interactor.intersect(PNBound(min: [-1, -1, -1], max: [1, 1, 1]),
                                           ray: PNRay(origin: .zero, direction: [0, 1, 0])))
    }
    func testRayOutsideBoundPointingOutwardsPlusY() throws {
        XCTAssertFalse(interactor.intersect(PNBound(min: [-1, -1, -1], max: [1, 1, 1]),
                                            ray: PNRay(origin: [0, 10, 0], direction: [0, 1, 0])))
    }
    func testRayOutsideBoundPointingInwardsPlusY() throws {
        XCTAssertTrue(interactor.intersect(PNBound(min: [-1, -1, -1], max: [1, 1, 1]),
                                           ray: PNRay(origin: [0, 10, 0], direction: [0, -1, 0])))
    }
    func testRayOutsideBoundPointingOutwardsMinusY() throws {
        XCTAssertFalse(interactor.intersect(PNBound(min: [-1, -1, -1], max: [1, 1, 1]),
                                            ray: PNRay(origin: [0, -10, 0], direction: [0, -1, 0])))
    }
    func testRayOutsideBoundPointingInwardsMinusY() throws {
        XCTAssertTrue(interactor.intersect(PNBound(min: [-1, -1, -1], max: [1, 1, 1]),
                                           ray: PNRay(origin: [0, -10, 0], direction: [0, 1, 0])))
    }
    func testRayOutsideBoundPointingOutwardsPlusX() throws {
        XCTAssertFalse(interactor.intersect(PNBound(min: [-1, -1, -1], max: [1, 1, 1]),
                                            ray: PNRay(origin: [10, 0, 0], direction: [1, 0, 0])))
    }
    func testRayOutsideBoundPointingInwardsPlusX() throws {
        XCTAssertTrue(interactor.intersect(PNBound(min: [-1, -1, -1], max: [1, 1, 1]),
                                           ray: PNRay(origin: [10, 0, 0], direction: [-1, 0, 0])))
    }
    func testRayOutsideBoundPointingOutwardsMinusX() throws {
        XCTAssertFalse(interactor.intersect(PNBound(min: [-1, -1, -1], max: [1, 1, 1]),
                                            ray: PNRay(origin: [-10, 0, 0], direction: [-1, 0, 0])))
    }
    func testRayOutsideBoundPointingInwardsMinusX() throws {
        XCTAssertTrue(interactor.intersect(PNBound(min: [-1, -1, -1], max: [1, 1, 1]),
                                           ray: PNRay(origin: [-10, 0, 0], direction: [1, 0, 0])))
    }
    func testRayOutsideBoundPointingOutwardsPlusZ() throws {
        XCTAssertFalse(interactor.intersect(PNBound(min: [-1, -1, -1], max: [1, 1, 1]),
                                            ray: PNRay(origin: [0, 0, 10], direction: [0, 0, 1])))
    }
    func testRayOutsideBoundPointingInwardsPlusZ() throws {
        XCTAssertTrue(interactor.intersect(PNBound(min: [-1, -1, -1], max: [1, 1, 1]),
                                           ray: PNRay(origin: [0, 0, 10], direction: [0, 0, -1])))
    }
    func testRayOutsideBoundPointingOutwardsMinusZ() throws {
        XCTAssertFalse(interactor.intersect(PNBound(min: [-1, -1, -1], max: [1, 1, 1]),
                                            ray: PNRay(origin: [0, 0, -10], direction: [0, 0, -1])))
    }
    func testRayOutsideBoundPointingInwardsMinusZ() throws {
        XCTAssertTrue(interactor.intersect(PNBound(min: [-1, -1, -1], max: [1, 1, 1]),
                                           ray: PNRay(origin: [0, 0, -10], direction: [0, 0, 1])))
    }
}

class PNIBoundInteractorTests: XCTestCase {
    let interactor = PNIBoundInteractor()
    func testWidth() throws {
        XCTAssertEqual(interactor.width(PNBound(min: [-1, -2, -3], max: [1, 2, 3])), 2)
        XCTAssertEqual(interactor.width(PNBound(min: [-2, -2, -3], max: [-1, 2, 3])), 1)
        XCTAssertEqual(interactor.width(PNBound(min: [1, -2, -3], max: [4, 2, 3])), 3)
    }
    func testHeight() throws {
        XCTAssertEqual(interactor.height(PNBound(min: [-1, -2, -3], max: [1, 2, 3])), 4)
        XCTAssertEqual(interactor.height(PNBound(min: [-1, -2, -3], max: [1, -1, 3])), 1)
        XCTAssertEqual(interactor.height(PNBound(min: [-1, 2, -3], max: [1, 5, 3])), 3)
    }
    func testDepth() throws {
        XCTAssertEqual(interactor.depth(PNBound(min: [-1, -2, -3], max: [1, 2, 3])), 6)
        XCTAssertEqual(interactor.depth(PNBound(min: [-1, -2, -3], max: [1, 2, -2])), 1)
        XCTAssertEqual(interactor.depth(PNBound(min: [-1, -2, 3], max: [1, 2, 10])), 7)
    }
    func testCenter() throws {
        XCTAssertEqual(interactor.center(PNBound(min: [-1, -2, -3], max: [1, 2, 3])), [0, 0, 0])
        XCTAssertEqual(interactor.center(PNBound(min: [-1, -2, -3], max: [-0.5, -1, 0])), [-0.75, -1.5, -1.5])
        XCTAssertEqual(interactor.center(PNBound(min: [1, 2, 3], max: [5, 6, 9])), [3, 4, 6])
    }
}
