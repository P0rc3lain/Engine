//
//  Copyright © 2021 Mateusz Stompór. All rights reserved.
//

import XCTest
import Engine

class AnimatedValueTests: XCTestCase {
    
    var animation = AnimatedValue<String>(keyFrames: ["a", "b", "c"], times: [3, 5, 9], maximumTime: 10)
    
    func testBeforeFirst() throws {
        XCTAssertEqual(animation.sample(at: 2.55).current, "c")
        XCTAssertEqual(animation.sample(at: 2.55).upcoming, "a")
        XCTAssertEqual(animation.sample(at: 2.55).ratio, 0.8875)
    }
    
    func testAfterFirst() throws {
        XCTAssertEqual(animation.sample(at: 4).current, "a")
        XCTAssertEqual(animation.sample(at: 4).upcoming, "b")
        XCTAssertEqual(animation.sample(at: 4).ratio, 0.5)
    }
    
    func testBeforeLast() throws {
        XCTAssertEqual(animation.sample(at: 6.55).current, "b")
        XCTAssertEqual(animation.sample(at: 6.55).upcoming, "c")
        XCTAssertEqual(animation.sample(at: 6.55).ratio, 0.3875)
    }
    
    func testAfterLast() throws {
        XCTAssertEqual(animation.sample(at: 9.55).current, "c")
        XCTAssertEqual(animation.sample(at: 9.55).upcoming, "a")
        XCTAssertEqual(animation.sample(at: 9.55).ratio, 0.1375)
    }
    
    func testLoop() throws {
        XCTAssertEqual(animation.sample(at: 12.55).current, "c")
        XCTAssertEqual(animation.sample(at: 12.55).upcoming, "a")
    }
    
}
