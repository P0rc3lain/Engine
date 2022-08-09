//
//  Copyright © 2022 Mateusz Stompór. All rights reserved.
//

@testable import Engine
import simd
import XCTest

class PNIBoundingBoxGeneratorTests: XCTestCase {
    let generator = PNIBoundingBoxGenerator(interactor: PNIBoundingBoxInteractor.default)
    let boundInteractor = PNIBoundInteractor()
    let boundingBoxInteractor = PNIBoundingBoxInteractor.default
    func testEmptyScene() {
        let scene = PNSceneDescription()
        XCTAssertEqual(generator.boundingBoxes(scene: scene), [])
    }
    func testEmptyGroup() {
        let scene = PNSceneDescription()
        scene.entities.add(parentIdx: .nil, data: PNEntity(type: .group, referenceIdx: .nil))
        scene.uniforms.append(WModelUniforms(modelMatrix: .identity, modelMatrixInverse: .identity))
        scene.boundingBoxes = generator.boundingBoxes(scene: scene)
        assert(validate(scene: scene), "Scene improperly formed")
        XCTAssertEqual(scene.boundingBoxes, [.zero])
    }
    func testZeroSizedMeshNode() {
        let scene = PNSceneDescription()
        scene.meshes.append(PNMesh(boundingBox: .zero,
                                   vertexBuffer: PNDataBuffer(wholeBuffer: nil),
                                   pieceDescriptions: [],
                                   culling: .none(winding: .clockwise)))
        scene.entities.add(parentIdx: .nil, data: PNEntity(type: .mesh, referenceIdx: 0))
        scene.models.append(PNModelReference(mesh: 0, idx: 0))
        scene.uniforms.append(WModelUniforms(modelMatrix: .identity, modelMatrixInverse: .identity))
        scene.boundingBoxes = generator.boundingBoxes(scene: scene)
        assert(validate(scene: scene), "Scene improperly formed")
        XCTAssertEqual(scene.boundingBoxes, [.zero])
    }
    func testNonZeroSizedMeshNode() {
        let scene = PNSceneDescription()
        scene.meshes.append(PNMesh(boundingBox: PNIBoundingBoxInteractor.default.from(bound: PNBound(min: [0, 0, 0],
                                                                                                     max: [1, 1, 1])),
                                   vertexBuffer: PNDataBuffer(wholeBuffer: nil),
                                   pieceDescriptions: [],
                                   culling: .none(winding: .clockwise)))
        scene.entities.add(parentIdx: .nil, data: PNEntity(type: .mesh, referenceIdx: 0))
        scene.models.append(PNModelReference(mesh: 0, idx: 0))
        scene.uniforms.append(WModelUniforms(modelMatrix: .identity, modelMatrixInverse: .identity))
        scene.boundingBoxes = generator.boundingBoxes(scene: scene)
        assert(validate(scene: scene), "Scene improperly formed")
        XCTAssertEqual(scene.boundingBoxes.count, 1)
        XCTAssertTrue(boundInteractor.isEqual(boundingBoxInteractor.bound(scene.boundingBoxes[0]), PNBound(min: [0, 0, 0],
                                                                                                           max: [1, 1, 1])))
    }
    func testNestedMeshes() {
        let scene = PNSceneDescription()
        // First mesh
        scene.meshes.append(PNMesh(boundingBox: PNIBoundingBoxInteractor.default.from(bound: PNBound(min: [0, 0, 0],
                                                                                                     max: [1, 1, 1])),
                                   vertexBuffer: PNDataBuffer(wholeBuffer: nil),
                                   pieceDescriptions: [],
                                   culling: .none(winding: .clockwise)))
        scene.entities.add(parentIdx: .nil, data: PNEntity(type: .mesh, referenceIdx: 0))
        scene.models.append(PNModelReference(mesh: 0, idx: 0))
        scene.uniforms.append(WModelUniforms(modelMatrix: .identity, modelMatrixInverse: .identity))
        // Add second
        scene.meshes.append(PNMesh(boundingBox: PNIBoundingBoxInteractor.default.from(bound: PNBound(min: [-10, -20, -30],
                                                                                                     max: [10, 20, 30])),
                                   vertexBuffer: PNDataBuffer(wholeBuffer: nil),
                                   pieceDescriptions: [],
                                   culling: .none(winding: .clockwise)))
        scene.entities.add(parentIdx: 0, data: PNEntity(type: .mesh, referenceIdx: 1))
        scene.models.append(PNModelReference(mesh: 1, idx: 1))
        scene.uniforms.append(WModelUniforms(modelMatrix: .identity, modelMatrixInverse: .identity))
        // Generate bounding boxes
        scene.boundingBoxes = generator.boundingBoxes(scene: scene)
        assert(validate(scene: scene), "Scene improperly formed")
        XCTAssertEqual(scene.boundingBoxes.count, 2)
        // Parent bounding box should have implicit size of child plus its own
        XCTAssertTrue(boundInteractor.isEqual(boundingBoxInteractor.bound(scene.boundingBoxes[0]),
                                              boundingBoxInteractor.bound(scene.boundingBoxes[1])))
        XCTAssertTrue(boundInteractor.isEqual(boundingBoxInteractor.bound(scene.boundingBoxes[1]), PNBound(min: [-10, -20, -30],
                                                                                                           max: [10, 20, 30])))
    }
}
