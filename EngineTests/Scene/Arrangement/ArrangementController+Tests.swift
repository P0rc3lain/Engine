//
//  Copyright © 2021 Mateusz Stompór. All rights reserved.
//

@testable import Engine
import MetalBinding
import simd
import XCTest


class ArrangementControllerTests: XCTestCase {
    let boundInteractor = PNIBoundInteractor()
    let interactor = PNIBoundingBoxInteractor.default
    func testEmptyScene() throws {
        var scene = PNSceneDescription()
        let arrangement = ArrangementController.arrangement(scene: &scene)
        XCTAssertEqual(arrangement.positions, [])
        XCTAssertTrue(arrangement.boundingBoxes.isEmpty)
    }
    func testGroup() throws {
        var scene = PNSceneDescription()
        scene.entities.add(parentIdx: .nil, data: PNEntity(transform: .static(from: .translation(vector: [0, 0, 0])), type: .group, referenceIdx: .nil))
        scene.skeletonReferences.append(.nil)
        scene.entities.add(parentIdx: 0, data: PNEntity(transform: .static(from: .translation(vector: [4, 4, 4])), type: .ambientLight, referenceIdx: 0))
        scene.skeletonReferences.append(.nil)
        scene.ambientLights.append(AmbientLight(diameter: 10, color: [1, 1, 1], intensity: 0.2, idx: 1))
        let arrangement = ArrangementController.arrangement(scene: &scene)
        XCTAssertEqual(arrangement.positions.count, arrangement.boundingBoxes.count)
        XCTAssertEqual(arrangement.positions[0].modelMatrix.translation, [0, 0, 0])
        XCTAssertTrue(boundInteractor.isEqual(interactor.bound(arrangement.boundingBoxes[1]), PNBound(min: [-1, -1, -1], max: [9, 9, 9])))
        XCTAssertTrue(boundInteractor.isEqual(interactor.bound(arrangement.boundingBoxes[0]), PNBound(min: [-1, -1, -1], max: [9, 9, 9])))
    }
    func testTransformedGroup() throws {
        var scene = PNSceneDescription()
        scene.entities.add(parentIdx: .nil, data: PNEntity(transform: .static(from: .translation(vector: [2, 2, 2])), type: .group, referenceIdx: .nil))
        scene.skeletonReferences.append(.nil)
        scene.entities.add(parentIdx: 0, data: PNEntity(transform: .static(from: .translation(vector: [4, 4, 4])), type: .ambientLight, referenceIdx: 0))
        scene.skeletonReferences.append(.nil)
        scene.ambientLights.append(AmbientLight(diameter: 10, color: [1, 1, 1], intensity: 0.2, idx: 1))
        let arrangement = ArrangementController.arrangement(scene: &scene)
        XCTAssertEqual(arrangement.positions[0].modelMatrix.translation, [2, 2, 2])
        XCTAssertEqual(arrangement.positions[1].modelMatrix.translation, [6, 6, 6])
        XCTAssertTrue(boundInteractor.isEqual(interactor.bound(arrangement.boundingBoxes[1]), PNBound(min: [1, 1, 1], max: [11, 11, 11])))
        XCTAssertTrue(boundInteractor.isEqual(interactor.bound(arrangement.boundingBoxes[0]), PNBound(min: [1, 1, 1], max: [11, 11, 11])))
    }
    func testTransformedGroupMultipleChildren() throws {
        var scene = PNSceneDescription()
        scene.entities.add(parentIdx: .nil, data: PNEntity(transform: .static(from: .translation(vector: [2, 2, 2])), type: .group, referenceIdx: .nil))
        scene.skeletonReferences.append(.nil)
        scene.entities.add(parentIdx: 0, data: PNEntity(transform: .static(from: .translation(vector: [4, 4, 4])), type: .ambientLight, referenceIdx: 0))
        scene.skeletonReferences.append(.nil)
        scene.ambientLights.append(AmbientLight(diameter: 10, color: [1, 1, 1], intensity: 0.2, idx: 1))
        scene.entities.add(parentIdx: 0, data: PNEntity(transform: .static(from: .translation(vector: [10, 10, 10])), type: .ambientLight, referenceIdx: 1))
        scene.skeletonReferences.append(.nil)
        scene.ambientLights.append(AmbientLight(diameter: 20, color: [1, 1, 1], intensity: 0.2, idx: 2))
        let arrangement = ArrangementController.arrangement(scene: &scene)
        XCTAssertEqual(arrangement.positions[0].modelMatrix.translation, [2, 2, 2])
        XCTAssertEqual(arrangement.positions[1].modelMatrix.translation, [6, 6, 6])
        XCTAssertEqual(arrangement.positions[2].modelMatrix.translation, [12, 12, 12])
        XCTAssertTrue(boundInteractor.isEqual(interactor.bound(arrangement.boundingBoxes[0]), PNBound(min: [1, 1, 1], max: [22, 22, 22])))
        XCTAssertTrue(boundInteractor.isEqual(interactor.bound(arrangement.boundingBoxes[1]), PNBound(min: [1, 1, 1], max: [11, 11, 11])))
        XCTAssertTrue(boundInteractor.isEqual(interactor.bound(arrangement.boundingBoxes[2]), PNBound(min: [2, 2, 2], max: [22, 22, 22])))
    }
}
