//
//  Copyright © 2022 Mateusz Stompór. All rights reserved.
//

@testable import Engine
import PNShared
import simd
import XCTest

class PNIBoundEstimatorTests: XCTestCase {
    func testSingleVertexArray() {
        let vertex = Vertex(position: .zero,
                            normal: [0, 1, 0],
                            tangent: [1, 0, 0],
                            textureUV: .zero)
        let bound = PNIBoundEstimator().bound(vertexBuffer: [vertex])
        XCTAssertEqual(bound.min, .zero)
        XCTAssertEqual(bound.max, .zero)
    }
    func testTwoVertexArray() {
        let vertices = [
            Vertex(position: .zero,
                   normal: [0, 1, 0],
                   tangent: [1, 0, 0],
                   textureUV: .zero),
            Vertex(position: .one,
                   normal: [0, 1, 0],
                   tangent: [1, 0, 0],
                   textureUV: .zero)
        ]
        let bound = PNIBoundEstimator().bound(vertexBuffer: vertices)
        XCTAssertEqual(bound.min, .zero)
        XCTAssertEqual(bound.max, .one)
    }
    func testMultipleVertices() {
        let vertices = [
            Vertex(position: [-1, -5, -3],
                   normal: [0, 1, 0],
                   tangent: [1, 0, 0],
                   textureUV: .zero),
            Vertex(position: [-4, -2, -6],
                   normal: [0, 1, 0],
                   tangent: [1, 0, 0],
                   textureUV: .zero),
            Vertex(position: [4, 2, 6],
                   normal: [0, 1, 0],
                   tangent: [1, 0, 0],
                   textureUV: .zero),
            Vertex(position: [1, 5, 3],
                   normal: [0, 1, 0],
                   tangent: [1, 0, 0],
                   textureUV: .zero)
        ]
        let bound = PNIBoundEstimator().bound(vertexBuffer: vertices)
        XCTAssertEqual(bound.min, [-4, -5, -6])
        XCTAssertEqual(bound.max, [4, 5, 6])
    }
}
