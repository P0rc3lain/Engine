//
//  Copyright © 2021 Mateusz Stompór. All rights reserved.
//

@testable import Engine
import simd
import XCTest

class PNINodeInteractorTests: XCTestCase {
    let interactor = PNINodeInteractor()
    func testForEachNoChildren() throws {
        let node = PNNode<Int>(data: 2)
        interactor.forEach(node: node) { node in
            XCTAssertEqual(node.data, 2)
        }
    }
    func testForEachPassing() throws {
        let node = PNNode<Int>(data: 2)
        let child = PNNode<Int>(data: 5)
        node.children.append(child)
        interactor.forEach(node: node, passingClosure: { (node, passedValue: Int?) in
            if let passedValue = passedValue {
                XCTAssertEqual(node.data + passedValue, 7)
                return node.data + passedValue
            }
            return node.data
        })
    }
    func testForEachPassingMultipleChildren() throws {
        let node = PNNode<Int>(data: 2)
        let child = PNNode<Int>(data: 5)
        node.children.append(child)
        interactor.forEach(node: node, passingClosure: { (node, passedValue: Int?) in
            if let passedValue = passedValue {
                XCTAssertEqual(node.data + passedValue, 7)
                return node.data + passedValue
            }
            return node.data
        })
    }
    func testDeepSearchNoChildrenValueFound() throws {
        let node = PNNode<Int>(data: 2)
        let found = interactor.deepSearch(from: node) { n in
            n.data == 2
        }
        XCTAssertEqual(found.count, 1)
        XCTAssertEqual(found[0].data, 2)
    }
    func testDeepSearchNoChildrenValueNotFound() throws {
        let node = PNNode<Int>(data: 3)
        let found = interactor.deepSearch(from: node) { n in
            n.data == 2
        }
        XCTAssertEqual(found.count, 0)
    }
    func testDeepSearchChildrenValueFound() throws {
        let child = PNNode<Int>(data: 1)
        let parent = PNNode<Int>(data: 2)
        let grandParent = PNNode<Int>(data: 3)
        parent.add(child: child)
        grandParent.add(child: parent)
        let found = interactor.deepSearch(from: grandParent) { n in
            n.data > 1
        }
        XCTAssertEqual(found.count, 1)
        XCTAssertEqual(found[0].data, 2)
    }
}
