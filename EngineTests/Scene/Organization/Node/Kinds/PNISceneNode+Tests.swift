//
//  Copyright © 2022 Mateusz Stompór. All rights reserved.
//

@testable import Engine
import simd
import XCTest

class PNISceneNodeTests: XCTestCase {
    private let interactor = PNIBoundingBoxInteractor.default
    func testSingleNode() throws {
        let node = PNScenePiece.make(data: PNISceneNode(transform: .translation(vector: [2, 0, 0])))
        XCTAssertEqual(node.data.transform.value, .translation(vector: [2, 0, 0]))
        XCTAssertNil(node.data.intrinsicBoundingBox)
        XCTAssertNil(node.data.localBoundingBox.value)
        XCTAssertNil(node.data.worldBoundingBox.value)
        XCTAssertEqual(node.data.modelUniforms.value.modelMatrix.translation, [2, 0, 0])
        XCTAssertNil(node.data.childrenMergedBoundingBox.value)
        if let enclosingNode = node.data.enclosingNode.value.reference {
            XCTAssertIdentical(node, enclosingNode)
        } else {
            XCTFail("Unexpected nil")
        }
    }
    func testNestedNodes() throws {
        let node = PNScenePiece.make(data: PNISceneNode(transform: .translation(vector: [1, 2, 3])))
        let parent = PNScenePiece.make(data: PNISceneNode(transform: .translation(vector: [4, 5, 6])))
        let grandParent = PNScenePiece.make(data: PNISceneNode(transform: .translation(vector: [7, 8, 9])))
        parent.add(child: node)
        grandParent.add(child: parent)
        XCTAssertEqual(node.data.transform.value.translation, [1, 2, 3])
        XCTAssertEqual(node.data.worldTransform.value.translation, [12, 15, 18])
        XCTAssertEqual(node.data.modelUniforms.value.modelMatrix.translation, [12, 15, 18])
        XCTAssertEqual(parent.data.transform.value.translation, [4, 5, 6])
        XCTAssertEqual(parent.data.worldTransform.value.translation, [11, 13, 15])
        XCTAssertEqual(parent.data.modelUniforms.value.modelMatrix.translation, [11, 13, 15])
        XCTAssertEqual(grandParent.data.transform.value.translation, [7, 8, 9])
        XCTAssertEqual(grandParent.data.worldTransform.value.translation, [7, 8, 9])
        XCTAssertEqual(grandParent.data.modelUniforms.value.modelMatrix.translation, [7, 8, 9])
    }
    func testBoundingBox() throws {
        let bb = interactor.from(bound: PNBound(min: [-1, -1, -1], max: [1, 1, 1]))
        let node = PNScenePiece.make(data: PNISceneNode(transform: .translation(vector: [1, 2, 3]),
                                                        boundingBox: bb))
        XCTAssertEqual(node.data.worldTransform.value.translation, [1, 2, 3])
        XCTAssertEqual(node.data.worldTransform.value.translation,
                       node.data.transform.value.translation)
        
        XCTAssertEqual(interactor.bound(node.data.worldBoundingBox.value!).min,
                       interactor.bound(node.data.localBoundingBox.value!).min)
        XCTAssertEqual(interactor.bound(node.data.worldBoundingBox.value!).max,
                       interactor.bound(node.data.localBoundingBox.value!).max)
        if let bb = node.data.worldBoundingBox.value {
            XCTAssertEqual(interactor.bound(bb).min, [0, 1, 2])
            XCTAssertEqual(interactor.bound(bb).max, [2, 3, 4])
        } else {
            XCTFail("Unexpected nil")
        }
    }
    func testBoundingBoxNestedWithTranslations() throws {
        let bb = interactor.from(bound: PNBound(min: [-1, -1, -1], max: [1, 1, 1]))
        let node = PNScenePiece.make(data: PNISceneNode(transform: .translation(vector: [1, 2, 3]),
                                                        boundingBox: bb))
        let parentBb = interactor.from(bound: PNBound(min: [2, 2, 2], max: [4, 4, 4]))
        let parentNode = PNScenePiece.make(data: PNISceneNode(transform: .translation(vector: [4, 5, 6]),
                                                              boundingBox: parentBb))
        parentNode.add(child: node)
        XCTAssertEqual(parentNode.data.worldTransform.value.translation, [4, 5, 6])
        XCTAssertEqual(node.data.worldTransform.value.translation, [5, 7, 9])

        if let bbParent = parentNode.data.worldBoundingBox.value,
           let bbChild = node.data.worldBoundingBox.value,
           let bbChildLocal = node.data.localBoundingBox.value,
           let childrenMerged = parentNode.data.childrenMergedBoundingBox.value {
            XCTAssertEqual(interactor.bound(bbChild).min, [4, 6, 8])
            XCTAssertEqual(interactor.bound(bbChild).max, [6, 8, 10])
            XCTAssertEqual(interactor.bound(bbParent).min, [4, 6, 8])
            XCTAssertEqual(interactor.bound(bbParent).max, [8, 9, 10])
            XCTAssertEqual(interactor.bound(childrenMerged).min, [0, 1, 2])
            XCTAssertEqual(interactor.bound(childrenMerged).max, [2, 3, 4])
            XCTAssertEqual(interactor.bound(childrenMerged).min,
                           interactor.bound(bbChildLocal).min)
            XCTAssertEqual(interactor.bound(childrenMerged).max,
                           interactor.bound(bbChildLocal).max)
        } else {
            XCTFail("Unexpected nil")
        }
    }
    func testBoundingBoxNestedNoTranslation() throws {
        let firstBb = interactor.from(bound: PNBound(min: [-1, -1, -1], max: [5, 5, 5]))
        let firstNode = PNScenePiece.make(data: PNISceneNode(transform: .identity,
                                                             boundingBox: firstBb))
        let secondBb = interactor.from(bound: PNBound(min: [-4, -4, -4], max: [2, 2, 2]))
        let secondNode = PNScenePiece.make(data: PNISceneNode(transform: .identity,
                                                              boundingBox: secondBb))
        let parentBb = interactor.from(bound: PNBound(min: [-10, -10, -10], max: [4, 4, 4]))
        let parentNode = PNScenePiece.make(data: PNISceneNode(transform: .identity,
                                                              boundingBox: parentBb))
        parentNode.add(child: firstNode)
        parentNode.add(child: secondNode)
        let firstNodeWBB = interactor.bound(firstNode.data.worldBoundingBox.value!)
        let secondNodeWBB = interactor.bound(secondNode.data.worldBoundingBox.value!)
        let mergedChildrenWBB = interactor.bound(parentNode.data.childrenMergedBoundingBox.value!)
        let parentNodeWBB = interactor.bound(parentNode.data.worldBoundingBox.value!)
        XCTAssertEqual(firstNodeWBB.min, [-1, -1, -1])
        XCTAssertEqual(firstNodeWBB.max, [5, 5, 5])
        XCTAssertEqual(secondNodeWBB.min, [-4, -4, -4])
        XCTAssertEqual(secondNodeWBB.max, [2, 2, 2])
        XCTAssertEqual(mergedChildrenWBB.min, [-4, -4, -4])
        XCTAssertEqual(mergedChildrenWBB.max, [5, 5, 5])
        XCTAssertEqual(parentNodeWBB.min, [-10, -10, -10])
        XCTAssertEqual(parentNodeWBB.max, [5, 5, 5])
    }
    func testBoundingBoxNestedNoTranslationAfterBoundingBoxUpdate() throws {
        let firstBb = interactor.from(bound: PNBound(min: [-1, -1, -1], max: [5, 5, 5]))
        let firstNode = PNScenePiece.make(data: PNISceneNode(transform: .identity,
                                                             boundingBox: firstBb))
        let secondBb = interactor.from(bound: PNBound(min: [-4, -4, -4], max: [2, 2, 2]))
        let secondNode = PNScenePiece.make(data: PNISceneNode(transform: .identity,
                                                              boundingBox: secondBb))
        let parentBb = interactor.from(bound: PNBound(min: [-10, -10, -10], max: [4, 4, 4]))
        let parentNode = PNScenePiece.make(data: PNISceneNode(transform: .identity,
                                                              boundingBox: parentBb))
        parentNode.add(child: firstNode)
        parentNode.add(child: secondNode)
        secondNode.data.transform.send(.translation(vector: [20, 20, 20]))
        let firstNodeWBB = interactor.bound(firstNode.data.worldBoundingBox.value!)
        let secondNodeWBB = interactor.bound(secondNode.data.worldBoundingBox.value!)
        let mergedChildrenWBB = interactor.bound(parentNode.data.childrenMergedBoundingBox.value!)
        let parentNodeWBB = interactor.bound(parentNode.data.worldBoundingBox.value!)
        XCTAssertEqual(firstNodeWBB.min, [-1, -1, -1])
        XCTAssertEqual(firstNodeWBB.max, [5, 5, 5])
        XCTAssertEqual(secondNodeWBB.min, [16, 16, 16])
        XCTAssertEqual(secondNodeWBB.max, [22, 22, 22])
        XCTAssertEqual(mergedChildrenWBB.min, [-1, -1, -1])
        XCTAssertEqual(mergedChildrenWBB.max, [22, 22, 22])
        XCTAssertEqual(parentNodeWBB.min, [-10, -10, -10])
        XCTAssertEqual(parentNodeWBB.max, [22, 22, 22])
    }
}
