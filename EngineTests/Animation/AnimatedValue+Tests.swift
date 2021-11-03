//
//  Copyright © 2021 Mateusz Stompór. All rights reserved.
//

@testable import Engine
import XCTest

class AnimatedValueTests: XCTestCase {
    var animation = AnimatedValue<String>(keyFrames: ["a", "b", "c"], times: [3, 5, 9], maximumTime: 10)
    func testBeforeFirst() throws {
        XCTAssertEqual(animation.sample(at: 2.55).currentKeyFrame, "c")
        XCTAssertEqual(animation.sample(at: 2.55).upcomingKeyFrame, "a")
        XCTAssertEqual(animation.sample(at: 2.55).ratio, 0.887_5)
    }
    func testAfterFirst() throws {
        XCTAssertEqual(animation.sample(at: 4).currentKeyFrame, "a")
        XCTAssertEqual(animation.sample(at: 4).upcomingKeyFrame, "b")
        XCTAssertEqual(animation.sample(at: 4).ratio, 0.5)
    }
    func testBeforeLast() throws {
        XCTAssertEqual(animation.sample(at: 6.55).currentKeyFrame, "b")
        XCTAssertEqual(animation.sample(at: 6.55).upcomingKeyFrame, "c")
        XCTAssertEqual(animation.sample(at: 6.55).ratio, 0.387_5)
    }
    func testAfterLast() throws {
        XCTAssertEqual(animation.sample(at: 9.55).currentKeyFrame, "c")
        XCTAssertEqual(animation.sample(at: 9.55).upcomingKeyFrame, "a")
        XCTAssertEqual(animation.sample(at: 9.55).ratio, 0.137_5)
    }
    func testLoop() throws {
        let sample = animation.sample(at: 12.55)
        XCTAssertEqual(sample.currentKeyFrame, "c")
        XCTAssertEqual(sample.upcomingKeyFrame, "a")
        XCTAssertEqual(sample.ratio, 0.887_5)
    }
    func testLargeLoop() throws {
        let sample = animation.sample(at: 1_012.55)
        XCTAssertEqual(sample.currentKeyFrame, "c")
        XCTAssertEqual(sample.upcomingKeyFrame, "a")
        XCTAssertEqual(sample.ratio, 0.887_5)
    }
}
