//
//  Copyright © 2022 Mateusz Stompór. All rights reserved.
//

import simd

class PNIScreenInteractor: PNScreenInteractor {
    private let boundInteractor = PNIBoundInteractor()
    private let boundingBoxInteractor = PNIBoundingBoxInteractor.default
    private let nodeInteractor = PNINodeInteractor()
    private init() {
        // Default
    }
    func pick(camera cameraNode: PNCameraNode,
              scene: PNScene,
              point: PNPoint2D) -> [PNScenePiece] {
        let inverseProjection = cameraNode.camera.projectionMatrixInverse
        let direction = inverseProjection * simd_float4(point.x, point.y, 1, 1)
        let rayEye = PNRay(origin: .zero, direction: direction.xyz.normalized)
        let rayWorld = cameraNode.worldTransform.value * rayEye
        return nodeInteractor.deepSearch(from: scene.rootNode) { node in
            guard let value = node.data.worldBoundingBox.value else {
                return false
            }
            return boundInteractor.intersect(boundingBoxInteractor.bound(value), ray: rayWorld)
        }
    }
    static var `default`: PNIScreenInteractor {
        PNIScreenInteractor()
    }
}
