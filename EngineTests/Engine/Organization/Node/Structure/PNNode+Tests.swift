//
//  Copyright © 2022 Mateusz Stompór. All rights reserved.
//

@testable import Engine
import XCTest

class PNNodeTests: XCTestCase {
    func testContainsNonRelated() throws {
        let node = PNNode<Int>(data: 1, parent: nil, children: [])
        let otherNode = PNNode<Int>(data: 1, parent: nil, children: [])
        XCTAssertFalse(node.contains(node: otherNode))
    }
    func testContainsItself() throws {
        let node = PNNode<Int>(data: 1, parent: nil, children: [])
        XCTAssertTrue(node.contains(node: node))
    }
    func testContainsNested() throws {
        let nodeA = PNNode<Int>(data: 1, parent: nil, children: [])
        let nodeB = PNNode<Int>(data: 1, parent: nil, children: [])
        let nodeC = PNNode<Int>(data: 1, parent: nil, children: [])
        nodeA.add(child: nodeB)
        nodeB.add(child: nodeC)
        XCTAssertTrue(nodeA.contains(node: nodeC))
    }
}
