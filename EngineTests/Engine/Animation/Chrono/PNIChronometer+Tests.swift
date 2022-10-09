//
//  Copyright © 2021 Mateusz Stompór. All rights reserved.
//

@testable import Engine
import XCTest

class ChronometerTests: XCTestCase {
    func testInitPaused() {
        let chrono = PNIChronometer.paused
        XCTAssertTrue(chrono.isPaused)
    }
    func testInitialElapsedTime() {
        let chrono = PNIChronometer.paused
        XCTAssertEqual(chrono.elapsedTime, 0)
    }
    func testInitRunning() {
        let chrono = PNIChronometer.running
        XCTAssertFalse(chrono.isPaused)
    }
    func testPausePaused() {
        var chrono = PNIChronometer.paused
        chrono.pause()
        XCTAssertEqual(chrono.elapsedTime, 0)
    }
    func testElapsedTimeGrowing() {
        let chrono = PNIChronometer.running
        let probeA = chrono.elapsedTime
        usleep(1)
        let probeB = chrono.elapsedTime
        XCTAssertGreaterThan(probeB, probeA)
    }
    func testResumePaused() {
        var chrono = PNIChronometer.paused
        chrono.resume()
        XCTAssertGreaterThan(chrono.elapsedTime, 0)
    }
    func testResetPaused() {
        var chrono = PNIChronometer.running
        chrono.pause()
        chrono.reset()
        XCTAssertEqual(chrono.elapsedTime, 0)
    }
    func testResetRunning() {
        var chrono = PNIChronometer.running
        sleep(1)
        let sampleA = chrono.elapsedTime
        chrono.reset()
        usleep(1)
        let sampleB = chrono.elapsedTime
        XCTAssertGreaterThan(sampleA, sampleB)
        XCTAssertGreaterThan(sampleB, 0)
    }
}
