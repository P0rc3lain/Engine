//
//  Copyright © 2022 Mateusz Stompór. All rights reserved.
//

@testable import Engine
import simd
import XCTest

class PNIBoundingBoxGeneratorTests: XCTestCase {
    let generator = PNIBoundingBoxGenerator(interactor: PNIBoundingBoxInteractor.default)
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
}
