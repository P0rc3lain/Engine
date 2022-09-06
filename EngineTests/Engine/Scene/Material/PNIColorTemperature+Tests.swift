//
//  Copyright © 2022 Mateusz Stompór. All rights reserved.
//

@testable import Engine
import simd
import XCTest

class PNIColorTemperatureTests: XCTestCase {
    func testConvertHigh() throws {
        let rgb = PNIColorTemperature().convert(temperature: 35_000)
        XCTAssertEqual(rgb.x, 155, accuracy: 3)
        XCTAssertEqual(rgb.y, 187, accuracy: 3)
        XCTAssertEqual(rgb.z, 255, accuracy: 3)
    }
    func testConvertHigherMiddle() throws {
        let rgb = PNIColorTemperature().convert(temperature: 15_000)
        XCTAssertEqual(rgb.x, 181, accuracy: 3)
        XCTAssertEqual(rgb.y, 205, accuracy: 3)
        XCTAssertEqual(rgb.z, 255, accuracy: 3)
    }
    func testConvertMiddle() throws {
        let rgb = PNIColorTemperature().convert(temperature: 6_600)
        XCTAssertEqual(rgb.x, 255, accuracy: 3)
        XCTAssertEqual(rgb.y, 255, accuracy: 3)
        XCTAssertEqual(rgb.z, 255, accuracy: 3)
    }
    func testConvertLowerMiddle() throws {
        let rgb = PNIColorTemperature().convert(temperature: 5_000)
        XCTAssertEqual(rgb.x, 255, accuracy: 3)
        XCTAssertEqual(rgb.y, 228, accuracy: 3)
        XCTAssertEqual(rgb.z, 205, accuracy: 3)
    }
}
