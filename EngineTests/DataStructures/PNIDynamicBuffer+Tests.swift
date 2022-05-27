//
//  Copyright © 2021 Mateusz Stompór. All rights reserved.
//

@testable import Engine
import simd
import XCTest

class PNIDynamicBufferTests: XCTestCase {
    func testPullingOnEmpty() throws {
        guard let device = MTLCreateSystemDefaultDevice(),
              let dynamicBuffer = PNIDynamicBuffer<Int>(device: device,
                                                        initialCapacity: 1) else {
            throw XCTSkip("Could not initiate device")
        }
        XCTAssertEqual([], dynamicBuffer.pulled)
    }
    func testPullingOnNonEmpty() throws {
        guard let device = MTLCreateSystemDefaultDevice(),
              let dynamicBuffer = PNIDynamicBuffer<Int>(device: device,
                                                        initialCapacity: 1) else {
            throw XCTSkip("Could not initiate device")
        }
        var data = [1, 2, 3]
        dynamicBuffer.upload(data: &data)
        XCTAssertEqual(data, dynamicBuffer.pulled)
    }
    func testBufferName() throws {
        guard let device = MTLCreateSystemDefaultDevice(),
              let dynamicBuffer = PNIDynamicBuffer<Int>(device: device,
                                                        initialCapacity: 1) else {
            throw XCTSkip("Could not initiate device")
        }
        XCTAssertEqual(dynamicBuffer.buffer.label, "PNIDynamicBuffer<Int>")
    }
    func testExtending() throws {
        guard let device = MTLCreateSystemDefaultDevice(),
              let dynamicBuffer = PNIDynamicBuffer<Int>(device: device,
                                                        initialCapacity: 1) else {
            throw XCTSkip("Could not initiate device")
        }
        var data = [1, 2, 3]
        dynamicBuffer.upload(data: &data)
        data = [3, 2, 1, 0]
        dynamicBuffer.upload(data: &data)
        XCTAssertEqual(dynamicBuffer.pulled, [3, 2, 1, 0])
    }
}
