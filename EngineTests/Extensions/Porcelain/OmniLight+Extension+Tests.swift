//
//  Copyright © 2021 Mateusz Stompór. All rights reserved.
//

@testable import Engine
import MetalBinding
import simd
import XCTest

class OmniLightExtensionTests: XCTestCase {
    let accuracy: Float = 0.01
    let interactor = PNIBoundingBoxInteractor.default
    func testBoundingBox() throws {
        let projectionMatrix = simd_float4x4.perspectiveProjectionRightHand(fovyRadians: Float(90).radians,
                                                                            aspect: 1,
                                                                            nearZ: 0.01,
                                                                            farZ: 20)
        let light = OmniLight(color: [1, 1, 1],
                              intensity: 1,
                              idx: 0,
                              projectionMatrix: projectionMatrix,
                              projectionMatrixInverse: projectionMatrix.inverse,
                              castsShadows: 0)
//        let boundingBox = light.boundingBox
//        let bound = interactor.bound(boundingBox)
//        XCTAssertEqual(bound.max.x, 20, accuracy: accuracy)
//        XCTAssertEqual(bound.max.y, 20, accuracy: accuracy)
//        XCTAssertEqual(bound.max.z, 20, accuracy: accuracy)
//        XCTAssertEqual(bound.min.x, -20, accuracy: accuracy)
//        XCTAssertEqual(bound.min.y, -20, accuracy: accuracy)
//        XCTAssertEqual(bound.min.z, -20, accuracy: accuracy)
    }
}
