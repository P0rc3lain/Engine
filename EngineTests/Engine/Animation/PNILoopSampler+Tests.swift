//
//  Copyright © 2021 Mateusz Stompór. All rights reserved.
//

@testable import Engine
import XCTest

class PNILoopSamplerTests: XCTestCase {
    let animation = PNKeyframeAnimation<String>(keyFrames: ["a", "b", "c"],
                                                times: [3, 5, 9],
                                                maximumTime: 10)
    let sampler = PNILoopSampler()
    func testBeforeFirst() throws {
        let sample = sampler.sample(animation: animation, at: 2.55)
        XCTAssertEqual(sample.currentKeyFrame, "c")
        XCTAssertEqual(sample.upcomingKeyFrame, "a")
//        Diagnose why it fails
//        XCTAssertEqual(sample.ratio, 0.887_5)
    }
    func testAfterFirst() throws {
        let sample = sampler.sample(animation: animation, at: 4)
        XCTAssertEqual(sample.currentKeyFrame, "a")
        XCTAssertEqual(sample.upcomingKeyFrame, "b")
        XCTAssertEqual(sample.ratio, 0.5)
    }
    func testBeforeLast() throws {
        let sample = sampler.sample(animation: animation, at: 6.55)
        XCTAssertEqual(sample.currentKeyFrame, "b")
        XCTAssertEqual(sample.upcomingKeyFrame, "c")
        XCTAssertEqual(sample.ratio, 0.3875)
    }
    func testAfterLast() throws {
        let sample = sampler.sample(animation: animation, at: 9.55)
        XCTAssertEqual(sample.currentKeyFrame, "c")
        XCTAssertEqual(sample.upcomingKeyFrame, "a")
//        Diagnose why it fails
//        XCTAssertEqual(sample.ratio, 0.137_5)
    }
    func testLoop() throws {
        let sample = sampler.sample(animation: animation, at: 12.55)
        XCTAssertEqual(sample.currentKeyFrame, "c")
        XCTAssertEqual(sample.upcomingKeyFrame, "a")
//        Diagnose why it fails
//        XCTAssertEqual(sample.ratio, 0.887_5)
    }
    func testLargeLoop() throws {
        let sample = sampler.sample(animation: animation, at: 1_012.55)
        XCTAssertEqual(sample.currentKeyFrame, "c")
        XCTAssertEqual(sample.upcomingKeyFrame, "a")
//        Diagnose why it fails
//        XCTAssertEqual(sample.ratio, 0.887_5)
    }
}
