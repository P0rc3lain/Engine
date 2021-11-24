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
}
