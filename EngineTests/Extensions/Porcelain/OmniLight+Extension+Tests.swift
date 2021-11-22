//
//  Copyright © 2021 Mateusz Stompór. All rights reserved.
//

@testable import Engine
import MetalBinding
import simd
import XCTest

//class OmniLightExtensionTests: XCTestCase {
//    let accuracy: Float = 0.01
//    func testBoundingBox() throws {
//        let projectionMatrix = simd_float4x4.perspectiveProjectionRightHand(fovyRadians: Float(90).radians, aspect: 1, nearZ: 0.01, farZ: 20)
//        let light = OmniLight(color: [1, 1, 1], intensity: 1, idx: 0, projectionMatrix: projectionMatrix, projectionMatrixInverse: projectionMatrix.inverse)
//        let boundingBox = light.boundingBox
//        XCTAssertEqual(boundingBox.bound.max.x, 20, accuracy: accuracy)
//        XCTAssertEqual(boundingBox.bound.max.y, 20, accuracy: accuracy)
//        XCTAssertEqual(boundingBox.bound.max.z, 20, accuracy: accuracy)
//        XCTAssertEqual(boundingBox.bound.min.x, -20, accuracy: accuracy)
//        XCTAssertEqual(boundingBox.bound.min.y, -20, accuracy: accuracy)
//        XCTAssertEqual(boundingBox.bound.min.z, -20, accuracy: accuracy)
//    }
//}
