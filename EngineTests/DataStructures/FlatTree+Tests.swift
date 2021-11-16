//
//  Copyright © 2021 Mateusz Stompór. All rights reserved.
//

@testable import Engine
import simd
import XCTest

class FlatTreeTests: XCTestCase {
    func testChildrenEmptyTree() throws {
        let tree = FlatTree<Int>()
        XCTAssertEqual(tree.children(of: -1), [])
        XCTAssertEqual(tree.children(of: 0), [])
    }
    func testSingleNodeTree() throws {
        var tree = FlatTree<Int>()
        tree.add(parentIdx: .nil, data: 100)
        XCTAssertEqual(tree.children(of: -1), [0])
        XCTAssertEqual(tree.children(of: 0), [])
    }
    func testMultipleChildren() throws {
        var tree = FlatTree<Int>()
        tree.add(parentIdx: .nil, data: 100)
        tree.add(parentIdx: 0, data: 101)
        tree.add(parentIdx: 0, data: 102)
        tree.add(parentIdx: 1, data: 103)
        XCTAssertEqual(tree.children(of: -1), [0])
        XCTAssertEqual(tree.children(of: 0), [1, 2])
        XCTAssertEqual(tree.children(of: 1), [3])
    }
}
