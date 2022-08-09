//
//  Copyright © 2022 Mateusz Stompór. All rights reserved.
//

@testable import Engine
import XCTest
import simd

class DataExtensionTests: XCTestCase {
    func testSolid2DTexture() throws {
        let data = Data.solid2DTexture(color: [0.1, 0.2, 0.3, 1.0])
        XCTAssertEqual(data.count, 64 * 4)
        data.withUnsafeBytes { ptr in
            for value in ptr.bindMemory(to: simd_uchar4.self) {
                XCTAssertEqual(value, [76, 51, 25, 255])
            }
        }
    }
}
