//
//  Copyright © 2022 Mateusz Stompór. All rights reserved.
//

@testable import Engine
import XCTest

class ArrayExtensionTests: XCTestCase {
    func testInsert() throws {
        var empty = [Int]()
        empty.insert(10)
        XCTAssertEqual(empty.count, 1)
        XCTAssertEqual(empty[0], 10)
    }
    func testBytesCount() throws {
        var empty = [Int32]()
        XCTAssertEqual(empty.bytesCount, 0)
        empty.append(1)
        XCTAssertEqual(empty.bytesCount, 4)
    }
    func testReduceEmpty() throws {
        XCTAssertNil([Int]().reduce(+))
    }
    func testReduceSingleValue() throws {
        let values: [Int] = [1]
        XCTAssertEqual(values.reduce(+), Optional(1))
    }
    func testReduceNonEmpty() throws {
        XCTAssertEqual([1, 2, 3].reduce(+), Optional(Int(6)))
    }
    func testChunkedEmpty() throws {
        XCTAssertEqual([Int]().chunked(into: 1), [])
    }
    func testChunkedNonEmpty() throws {
        XCTAssertEqual([1, 2, 3].chunked(into: 1), [[1], [2], [3]])
    }
    func testChunkedNonEmptyNonEqualChunks() throws {
        XCTAssertEqual([1, 2, 3].chunked(into: 2), [[1, 2], [3]])
    }
    func testInplaceMap() throws {
        var values = [1, 2, 3]
        values.inplaceMap(transform: { $0 * 2 })
        XCTAssertEqual(values, [2, 4, 6])
    }
    func testMinimalCapacity() throws {
        let collection = [Int](minimalCapacity: 10)
        XCTAssertEqual(collection.capacity, 10)
        XCTAssertEqual(collection.count, 0)
    }
}
