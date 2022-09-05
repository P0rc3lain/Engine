//
//  Copyright © 2022 Mateusz Stompór. All rights reserved.
//

@testable import Engine
import simd
import XCTest

class PNIBoundInteractorGeneral: XCTestCase {
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
    func testVolume() throws {
        XCTAssertEqual(interactor.volume(PNBound(min: [-1, -2, -3], max: [1, 2, 3])), 48)
        XCTAssertEqual(interactor.volume(PNBound(min: [0, 0, 0], max: [1, 1, 1])), 1)
        XCTAssertEqual(interactor.volume(PNBound(min: [0, 0, 0], max: [1, 2, 3])), 6)
    }
}
