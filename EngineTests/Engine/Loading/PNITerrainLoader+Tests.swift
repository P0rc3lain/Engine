//
//  Copyright © 2022 Mateusz Stompór. All rights reserved.
//

@testable import Engine
import PNShared
import simd
import XCTest

class PNITerrainLoaderTests: XCTestCase {
    func testSimpleIndicesGeneration() {
        let indices = PNITerrainLoader.indices(width: 4, height: 2)
        XCTAssertEqual(indices, [0, 4, 1, 5, 2, 6, 3, 7])
    }
}
