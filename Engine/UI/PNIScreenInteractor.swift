//
//  Copyright © 2022 Mateusz Stompór. All rights reserved.
//

import simd

class PNIScreenInteractor: PNScreenInteractor {
    private let boundInteractor = PNIBoundInteractor.default
    private let boundingBoxInteractor = PNIBoundingBoxInteractor.default
    private let nodeInteractor = PNINodeInteractor()
    init() {
        // Default
    }
    func pick(camera cameraNode: PNCameraNode,
              scene: PNScene,
              point: PNPoint2D) -> [PNScenePiece] {
        let inverseProjection = cameraNode.camera.projectionMatrixInverse
        let direction: simd_float3 = [point.x, point.y, -1]
        let rayEye = inverseProjection * PNRay(origin: .zero, direction: direction)
        let transform = cameraNode.worldTransform.value
        let rayWorld = transform * PNRay(origin: .zero, direction: [rayEye.direction.x,
                                                                    rayEye.direction.y,
                                                                    -1])
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
