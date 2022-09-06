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
    func testFindNothingMatches() throws {
        let node = PNNode<Int>(data: 1)
        XCTAssertNil(node.findNode(where: { $0.data == 3 }))
    }
    func testFindMatch() throws {
        let node = PNNode<Int>(data: 1)
        XCTAssertIdentical(node.findNode(where: { $0.data == 1 }), node)
    }
    func testFindSingleMatchComplexStructure() throws {
        let child = PNNode<Int>(data: 1)
        let parent = PNNode<Int>(data: 2, children: [child])
        let grandParent = PNNode<Int>(data: 3, children: [parent])
        XCTAssertIdentical(grandParent.findNode(where: { $0.data == 1 }), child)
    }
    func testFindNoMatchComplexStructure() throws {
        let child = PNNode<Int>(data: 1)
        let parent = PNNode<Int>(data: 2, children: [child])
        let grandParent = PNNode<Int>(data: 3, children: [parent])
        XCTAssertNil(grandParent.findNode(where: { $0.data == 10 }))
    }
    func testFindAllAllMatches() throws {
        let grandChild = PNNode<Int>(data: 0)
        let child = PNNode<Int>(data: 1, children: [grandChild])
        let parent = PNNode<Int>(data: 2, children: [child])
        let grandParent = PNNode<Int>(data: 3, children: [parent])
        let allNodes = grandParent.findAllNodes(where: { $0.data >= 0 })
        XCTAssertEqual(allNodes.count, 4)
        XCTAssertIdentical(allNodes[0], grandParent)
        XCTAssertIdentical(allNodes[1], parent)
        XCTAssertIdentical(allNodes[2], child)
        XCTAssertIdentical(allNodes[3], grandChild)
    }
    func testFindAllSomeMatches() throws {
        let grandChild = PNNode<Int>(data: 0)
        let child = PNNode<Int>(data: 1, children: [grandChild])
        let parent = PNNode<Int>(data: 2, children: [child])
        let grandParent = PNNode<Int>(data: 3, children: [parent])
        let allNodes = grandParent.findAllNodes(where: { $0.data >= 2 })
        XCTAssertEqual(allNodes.count, 2)
        XCTAssertIdentical(allNodes[0], grandParent)
        XCTAssertIdentical(allNodes[1], parent)
    }
    func testFindAllNoMatch() throws {
        let grandChild = PNNode<Int>(data: 0)
        let child = PNNode<Int>(data: 1, children: [grandChild])
        let parent = PNNode<Int>(data: 2, children: [child])
        let grandParent = PNNode<Int>(data: 3, children: [parent])
        let allNodes = grandParent.findAllNodes(where: { $0.data < 0 })
        XCTAssertEqual(allNodes.count, 0)
    }
}
