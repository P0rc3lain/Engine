//
//  Copyright © 2021 Mateusz Stompór. All rights reserved.
//

@testable import Engine
import MetalBinding
import simd
import XCTest


class ArrangementControllerTests: XCTestCase {
//    func testEmptyScene() throws {
//        var scene = RamSceneDescription()
//        let arrangement = ArrangementController.arrangement(scene: &scene)
//        XCTAssertEqual(arrangement.worldPositions, [])
//        XCTAssertEqual(arrangement.worldBoundingBoxes, [])
//    }
//    func testGroup() throws {
//        var scene = RamSceneDescription()
//        scene.entities.add(parentIdx: .nil, data: Entity(transform: .static(from: .translation(vector: [0, 0, 0])), type: .group, referenceIdx: .nil))
//        scene.entityNames.append("Entity 1")
//        scene.skeletonReferences.append(.nil)
//        scene.entities.add(parentIdx: 0, data: Entity(transform: .static(from: .translation(vector: [4, 4, 4])), type: .ambientLight, referenceIdx: 0))
//        scene.entityNames.append("Entity 2")
//        scene.skeletonReferences.append(.nil)
//        scene.ambientLights.append(AmbientLight(diameter: 10, color: [1, 1, 1], intensity: 0.2, idx: 1))
//        scene.ambientLightNames.append("Ambient light")
//        let arrangement = ArrangementController.arrangement(scene: &scene)
//        XCTAssertEqual(arrangement.worldPositions.count, arrangement.worldBoundingBoxes.count)
//        XCTAssertEqual(arrangement.worldPositions[0].modelMatrix.translation, [0, 0, 0])
//        XCTAssertEqual(arrangement.worldBoundingBoxes[1].bound, Bound(min: [-1, -1, -1], max: [9, 9, 9]))
//        XCTAssertEqual(arrangement.worldBoundingBoxes[0].bound, Bound(min: [-1, -1, -1], max: [9, 9, 9]))
//    }
//    func testTransformedGroup() throws {
//        var scene = RamSceneDescription()
//        scene.entities.add(parentIdx: .nil, data: Entity(transform: .static(from: .translation(vector: [2, 2, 2])), type: .group, referenceIdx: .nil))
//        scene.entityNames.append("Entity 1")
//        scene.skeletonReferences.append(.nil)
//        scene.entities.add(parentIdx: 0, data: Entity(transform: .static(from: .translation(vector: [4, 4, 4])), type: .ambientLight, referenceIdx: 0))
//        scene.entityNames.append("Entity 2")
//        scene.skeletonReferences.append(.nil)
//        scene.ambientLights.append(AmbientLight(diameter: 10, color: [1, 1, 1], intensity: 0.2, idx: 1))
//        scene.ambientLightNames.append("Ambient light")
//        let arrangement = ArrangementController.arrangement(scene: &scene)
//        XCTAssertEqual(arrangement.worldPositions[0].modelMatrix.translation, [2, 2, 2])
//        XCTAssertEqual(arrangement.worldPositions[1].modelMatrix.translation, [6, 6, 6])
//        XCTAssertEqual(arrangement.worldBoundingBoxes[0].bound, Bound(min: [1, 1, 1], max: [11, 11, 11]))
//        XCTAssertEqual(arrangement.worldBoundingBoxes[1].bound, Bound(min: [1, 1, 1], max: [11, 11, 11]))
//    }
//    func testTransformedGroupMultipleChildren() throws {
//        var scene = RamSceneDescription()
//        scene.entities.add(parentIdx: .nil, data: Entity(transform: .static(from: .translation(vector: [2, 2, 2])), type: .group, referenceIdx: .nil))
//        scene.entityNames.append("Entity 1")
//        scene.skeletonReferences.append(.nil)
//        scene.entities.add(parentIdx: 0, data: Entity(transform: .static(from: .translation(vector: [4, 4, 4])), type: .ambientLight, referenceIdx: 0))
//        scene.entityNames.append("Entity 2")
//        scene.skeletonReferences.append(.nil)
//        scene.ambientLights.append(AmbientLight(diameter: 10, color: [1, 1, 1], intensity: 0.2, idx: 1))
//        scene.ambientLightNames.append("Ambient light 1")
//        scene.entities.add(parentIdx: 0, data: Entity(transform: .static(from: .translation(vector: [10, 10, 10])), type: .ambientLight, referenceIdx: 1))
//        scene.entityNames.append("Entity 3")
//        scene.skeletonReferences.append(.nil)
//        scene.ambientLights.append(AmbientLight(diameter: 20, color: [1, 1, 1], intensity: 0.2, idx: 2))
//        scene.ambientLightNames.append("Ambient light 2")
//        let arrangement = ArrangementController.arrangement(scene: &scene)
//        XCTAssertEqual(arrangement.worldPositions[0].modelMatrix.translation, [2, 2, 2])
//        XCTAssertEqual(arrangement.worldPositions[1].modelMatrix.translation, [6, 6, 6])
//        XCTAssertEqual(arrangement.worldPositions[2].modelMatrix.translation, [12, 12, 12])
//        XCTAssertEqual(arrangement.worldBoundingBoxes[0].bound, Bound(min: [1, 1, 1], max: [22, 22, 22]))
//        XCTAssertEqual(arrangement.worldBoundingBoxes[1].bound, Bound(min: [1, 1, 1], max: [11, 11, 11]))
//        XCTAssertEqual(arrangement.worldBoundingBoxes[2].bound, Bound(min: [2, 2, 2], max: [22, 22, 22]))
//    }
}
