//
//  Copyright © 2022 Mateusz Stompór. All rights reserved.
//

@testable import Engine
import simd
import XCTest

class PNITranscriberTests: XCTestCase {
    let transcriber = PNITranscriber.default
    func testEmpty() throws {
        let scene = transcriber.transcribe(scene: PNScene.default)
        XCTAssertEqual(scene.entities.count, 1)
        XCTAssertEqual(scene.uniforms.count, 1)
        XCTAssertEqual(scene.boundingBoxes.count, 1)
        XCTAssertTrue(scene.models.isEmpty)
        XCTAssertTrue(scene.animatedModels.isEmpty)
        XCTAssertTrue(scene.paletteOffset.isEmpty)
        XCTAssertTrue(scene.meshes.isEmpty)
        XCTAssertTrue(scene.skeletons.isEmpty)
        XCTAssertTrue(scene.palettes.isEmpty)
        XCTAssertTrue(scene.cameras.isEmpty)
        XCTAssertTrue(scene.cameraUniforms.isEmpty)
        XCTAssertTrue(scene.omniLights.isEmpty)
        XCTAssertTrue(scene.ambientLights.isEmpty)
        XCTAssertTrue(scene.directionalLights.isEmpty)
        XCTAssertTrue(scene.spotLights.isEmpty)
        XCTAssertTrue(scene.particles.isEmpty)
        XCTAssertNil(scene.skyMap)
        XCTAssertEqual(scene.activeCameraIdx, .nil)
    }
}
