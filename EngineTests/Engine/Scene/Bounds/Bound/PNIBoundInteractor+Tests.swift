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
