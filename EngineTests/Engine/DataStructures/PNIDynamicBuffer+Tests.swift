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
        dynamicBuffer.upload(data: [1, 2, 3])
        XCTAssertEqual([1, 2, 3], dynamicBuffer.pulled)
    }
    func testBufferName() throws {
        guard let device = MTLCreateSystemDefaultDevice(),
              let dynamicBuffer = PNIDynamicBuffer<Int>(device: device,
                                                        initialCapacity: 1) else {
            throw XCTSkip("Could not initiate device")
        }
        XCTAssertEqual("PNIDynamicBuffer<Int>", dynamicBuffer.buffer.label)
    }
    func testExtending() throws {
        guard let device = MTLCreateSystemDefaultDevice(),
              let dynamicBuffer = PNIDynamicBuffer<Int>(device: device,
                                                        initialCapacity: 1) else {
            throw XCTSkip("Could not initiate device")
        }
        dynamicBuffer.upload(data: [1, 2, 3])
        dynamicBuffer.upload(data: [3, 2, 1, 0])
        XCTAssertEqual([3, 2, 1, 0], dynamicBuffer.pulled)
    }
}
