//
//  Copyright © 2021 Mateusz Stompór. All rights reserved.
//

@testable import Engine
import simd
import XCTest

class DynamicBufferTests: XCTestCase {
    func testPullingOnEmpty() throws {
        guard let device = MTLCreateSystemDefaultDevice(),
              let dynamicBuffer = DynamicBuffer<Int>(device: device, initialCapacity: 1) else {
            XCTFail("Could not initiate device")
            return
        }
        XCTAssertEqual([], dynamicBuffer.pulled)
    }
    func testPullingOnNonEmpty() throws {
        guard let device = MTLCreateSystemDefaultDevice(),
              var dynamicBuffer = DynamicBuffer<Int>(device: device, initialCapacity: 1) else {
            XCTFail("Could not initiate device")
            return
        }
        var data = [1, 2, 3]
        dynamicBuffer.upload(data: &data)
        XCTAssertEqual(data, dynamicBuffer.pulled)
    }
    func testBufferName() throws {
        guard let device = MTLCreateSystemDefaultDevice(),
              let dynamicBuffer = DynamicBuffer<Int>(device: device, initialCapacity: 1) else {
            XCTFail("Could not initiate device")
            return
        }
        XCTAssertEqual(dynamicBuffer.buffer.label, "DynamicBuffer<Int>")
    }
    func testExtending() throws {
        guard let device = MTLCreateSystemDefaultDevice(),
              var dynamicBuffer = DynamicBuffer<Int>(device: device, initialCapacity: 1) else {
            XCTFail("Could not initiate device")
            return
        }
        var data = [1, 2, 3]
        dynamicBuffer.upload(data: &data)
        data = [3, 2, 1, 0]
        dynamicBuffer.upload(data: &data)
        XCTAssertEqual(dynamicBuffer.pulled, [3, 2, 1, 0])
    }
}
