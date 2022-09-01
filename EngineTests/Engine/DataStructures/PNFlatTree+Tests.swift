//
//  Copyright © 2021 Mateusz Stompór. All rights reserved.
//

@testable import Engine
import simd
import XCTest

class PNFlatTreeTests: XCTestCase {
    func testChildrenEmptyTree() throws {
        let tree = PNFlatTree<Int>()
        XCTAssertEqual(tree.children(of: .nil), [])
        XCTAssertEqual(tree.children(of: 0), [])
    }
    func testSingleNodeTree() throws {
        var tree = PNFlatTree<Int>()
        tree.add(parentIdx: .nil, data: 100)
        XCTAssertEqual(tree.children(of: .nil), [0])
        XCTAssertEqual(tree.children(of: 0), [])
    }
    func testMultipleChildren() throws {
        var tree = PNFlatTree<Int>()
        tree.add(parentIdx: .nil, data: 100)
        tree.add(parentIdx: 0, data: 101)
        tree.add(parentIdx: 0, data: 102)
        tree.add(parentIdx: 1, data: 103)
        XCTAssertEqual(tree.children(of: .nil), [0])
        XCTAssertEqual(tree.children(of: 0), [1, 2])
        XCTAssertEqual(tree.children(of: 1), [3])
    }
    func testNonExistingDescendants() throws {
        let tree = PNFlatTree<Int>()
        XCTAssertEqual(tree.children(of: .nil), [])
        XCTAssertEqual(tree.children(of: 10), [])
    }
    func testDifferentAncestors() throws {
        var tree = PNFlatTree<Int>()
        tree.add(parentIdx: .nil, data: 100)
        tree.add(parentIdx: 0, data: 101)
        tree.add(parentIdx: 0, data: 102)
        tree.add(parentIdx: 1, data: 103)
        tree.add(parentIdx: 2, data: 104)
        XCTAssertEqual(tree.descendants(of: 1), [3])
        XCTAssertEqual(tree.descendants(of: 2), [4])
    }
    func testMultipleDescendants() throws {
        var tree = PNFlatTree<Int>()
        tree.add(parentIdx: .nil, data: 100)
        tree.add(parentIdx: 0, data: 101)
        tree.add(parentIdx: 0, data: 102)
        tree.add(parentIdx: 1, data: 103)
        XCTAssertEqual(tree.descendants(of: .nil), [0, 1, 2, 3])
    }
    func testEmptyOnEmpty() throws {
        let tree = PNFlatTree<Int>()
        XCTAssertTrue(tree.isEmpty)
    }
    func testEmptyOnNonEmpty() throws {
        var tree = PNFlatTree<Int>()
        tree.add(parentIdx: .nil, data: 10)
        XCTAssertFalse(tree.isEmpty)
    }
    func testCountOnEmpty() throws {
        let tree = PNFlatTree<Int>()
        XCTAssertEqual(tree.count, 0)
    }
    func testCountOnNonEmpty() throws {
        var tree = PNFlatTree<Int>()
        tree.add(parentIdx: .nil, data: 20)
        XCTAssertEqual(tree.count, 1)
    }
    func testIndicesOnEmpty() throws {
        XCTAssertEqual(PNFlatTree<Int>().indices, 0 ..< 0)
    }
    func testIndicesOnNonEmpty() throws {
        var tree = PNFlatTree<Int>()
        tree.add(parentIdx: .nil, data: 20)
        XCTAssertEqual(tree.indices, 0 ..< 1)
    }
    func testSubscript() throws {
        var tree = PNFlatTree<Int>()
        tree.add(parentIdx: .nil, data: 20)
        // update
        tree[0].data = 100
        XCTAssertEqual(tree[0].data, 100)
        XCTAssertEqual(tree[0].parentIdx, .nil)
    }
}
