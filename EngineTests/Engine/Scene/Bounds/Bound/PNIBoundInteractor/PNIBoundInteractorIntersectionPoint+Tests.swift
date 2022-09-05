//
//  Copyright © 2022 Mateusz Stompór. All rights reserved.
//

@testable import Engine
import XCTest

class PNIBoundInteractorIntersectionPointTests: XCTestCase {
    let interactor = PNIBoundInteractor()
    func testRayInBoundXMaxCollision() throws {
        let bound = PNBound(min: [-1, -2, -3], max: [4, 5, 6])
        let ray = PNRay(origin: .zero, direction: [1, 0, 0])
        XCTAssertEqual(interactor.intersectionPoint(bound, ray: ray), [4, 0, 0])
        let bound2 = PNBound(min: [-4, -5, -6], max: [-1, -2, -3])
        let ray2 = PNRay(origin: [-2, -3, -4], direction: [1, 0, 0])
        XCTAssertEqual(interactor.intersectionPoint(bound2, ray: ray2), [-1, -3, -4])
        let bound3 = PNBound(min: [1, 2, 3], max: [4, 5, 6])
        let ray3 = PNRay(origin: [2, 3, 4], direction: [1, 0, 0])
        XCTAssertEqual(interactor.intersectionPoint(bound3, ray: ray3), [4, 3, 4])
    }
    func testRayInBoundXMinCollision() throws {
        let bound = PNBound(min: [-1, -2, -3], max: [4, 5, 6])
        let ray = PNRay(origin: .zero, direction: [-1, 0, 0])
        XCTAssertEqual(interactor.intersectionPoint(bound, ray: ray), [-1, 0, 0])
        let bound2 = PNBound(min: [-4, -5, -6], max: [-1, -2, -3])
        let ray2 = PNRay(origin: [-2, -3, -4], direction: [-1, 0, 0])
        XCTAssertEqual(interactor.intersectionPoint(bound2, ray: ray2), [-4, -3, -4])
        let bound3 = PNBound(min: [1, 2, 3], max: [4, 5, 6])
        let ray3 = PNRay(origin: [2, 3, 4], direction: [-1, 0, 0])
        XCTAssertEqual(interactor.intersectionPoint(bound3, ray: ray3), [1, 3, 4])
    }
    func testRayInBoundYMaxCollision() throws {
        let bound = PNBound(min: [-1, -2, -3], max: [4, 5, 6])
        let ray = PNRay(origin: .zero, direction: [0, 1, 0])
        let point = interactor.intersectionPoint(bound, ray: ray)
        XCTAssertEqual(point, [0, 5, 0])
        let bound2 = PNBound(min: [-4, -5, -6], max: [-1, -2, -3])
        let ray2 = PNRay(origin: [-2, -3, -4], direction: [0, 1, 0])
        XCTAssertEqual(interactor.intersectionPoint(bound2, ray: ray2), [-2, -2, -4])
        let bound3 = PNBound(min: [1, 2, 3], max: [4, 5, 6])
        let ray3 = PNRay(origin: [2, 3, 4], direction: [0, 1, 0])
        XCTAssertEqual(interactor.intersectionPoint(bound3, ray: ray3), [2, 5, 4])
    }
    func testRayInBoundYMinCollision() throws {
        let bound = PNBound(min: [-1, -2, -3], max: [4, 5, 6])
        let ray = PNRay(origin: .zero, direction: [0, -1, 0])
        let point = interactor.intersectionPoint(bound, ray: ray)
        XCTAssertEqual(point, [0, -2, 0])
        let bound2 = PNBound(min: [-4, -5, -6], max: [-1, -2, -3])
        let ray2 = PNRay(origin: [-2, -3, -4], direction: [0, -1, 0])
        XCTAssertEqual(interactor.intersectionPoint(bound2, ray: ray2), [-2, -5, -4])
        let bound3 = PNBound(min: [1, 2, 3], max: [4, 5, 6])
        let ray3 = PNRay(origin: [2, 3, 4], direction: [0, -1, 0])
        XCTAssertEqual(interactor.intersectionPoint(bound3, ray: ray3), [2, 2, 4])
    }
    func testRayInBoundZMaxCollision() throws {
        let bound = PNBound(min: [-1, -2, -3], max: [4, 5, 6])
        let ray = PNRay(origin: .zero, direction: [0, 0, 1])
        let point = interactor.intersectionPoint(bound, ray: ray)
        XCTAssertEqual(point, [0, 0, 6])
        let bound2 = PNBound(min: [-4, -5, -6], max: [-1, -2, -3])
        let ray2 = PNRay(origin: [-2, -3, -4], direction: [0, 0, 1])
        XCTAssertEqual(interactor.intersectionPoint(bound2, ray: ray2), [-2, -3, -3])
        let bound3 = PNBound(min: [1, 2, 3], max: [4, 5, 6])
        let ray3 = PNRay(origin: [2, 3, 4], direction: [0, 0, 1])
        XCTAssertEqual(interactor.intersectionPoint(bound3, ray: ray3), [2, 3, 6])
    }
    func testRayInBoundZMinCollision() throws {
        let bound = PNBound(min: [-1, -2, -3], max: [4, 5, 6])
        let ray = PNRay(origin: .zero, direction: [0, 0, -1])
        let point = interactor.intersectionPoint(bound, ray: ray)
        XCTAssertEqual(point, [0, 0, -3])
        let bound2 = PNBound(min: [-4, -5, -6], max: [-1, -2, -3])
        let ray2 = PNRay(origin: [-2, -3, -4], direction: [0, 0, -1])
        XCTAssertEqual(interactor.intersectionPoint(bound2, ray: ray2), [-2, -3, -6])
        let bound3 = PNBound(min: [1, 2, 3], max: [4, 5, 6])
        let ray3 = PNRay(origin: [2, 3, 4], direction: [0, 0, -1])
        XCTAssertEqual(interactor.intersectionPoint(bound3, ray: ray3), [2, 3, 3])
    }
    func testRayOutsideBound() throws {
        let bound = PNBound(min: [-1, -2, -3], max: [2, 3, 4])
        let ray = PNRay(origin: [0, 0, -10], direction: [0, 0, 1])
        let point = interactor.intersectionPoint(bound, ray: ray)
        XCTAssertEqual(point, [0, 0, -3])
    }
    func testRayCornerIntersection() throws {
        let bound = PNBound(min: [-1, -2, -3], max: [1, 2, 3])
        let ray = PNRay(origin: [2, 3, 4], direction: PNPoint3D([-1, -1, -1]).normalized)
        let point = interactor.intersectionPoint(bound, ray: ray)
        XCTAssertEqual(point, [1, 2, 3])
    }
}
