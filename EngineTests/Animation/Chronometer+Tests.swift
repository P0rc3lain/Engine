//
//  Copyright © 2021 Mateusz Stompór. All rights reserved.
//

@testable import Engine
import XCTest

class ChronometerTests: XCTestCase {
    func testInitPaused() {
        let chrono = Chronometer.paused
        XCTAssertTrue(chrono.isPaused)
    }
    func testInitialElapsedTime() {
        let chrono = Chronometer.paused
        XCTAssertEqual(chrono.elapsedTime, 0)
    }
    func testInitRunning() {
        let chrono = Chronometer.running
        XCTAssertFalse(chrono.isPaused)
    }
    func testPausePaused() {
        var chrono = Chronometer.paused
        chrono.pause()
        XCTAssertEqual(chrono.elapsedTime, 0)
    }
    func testElapsedTimeGrowing() {
        let chrono = Chronometer.running
        let probeA = chrono.elapsedTime
        usleep(1)
        let probeB = chrono.elapsedTime
        XCTAssertGreaterThan(probeB, probeA)
    }
    func testResumePaused() {
        var chrono = Chronometer.paused
        chrono.resume()
        XCTAssertGreaterThan(chrono.elapsedTime, 0)
    }
    func testResetPaused() {
        var chrono = Chronometer.running
        chrono.pause()
        chrono.reset()
        XCTAssertEqual(chrono.elapsedTime, 0)
    }
    func testResetRunning() {
        var chrono = Chronometer.running
        sleep(1)
        let sampleA = chrono.elapsedTime
        chrono.reset()
        usleep(1)
        let sampleB = chrono.elapsedTime
        XCTAssertGreaterThan(sampleA, sampleB)
        XCTAssertGreaterThan(sampleB, 0)
    }
}
