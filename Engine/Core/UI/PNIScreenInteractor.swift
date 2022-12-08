//
//  Copyright © 2022 Mateusz Stompór. All rights reserved.
//

import simd

class PNIScreenInteractor: PNScreenInteractor {
    private let boundInteractor = PNIBoundInteractor()
    private let boundingBoxInteractor = PNIBoundingBoxInteractor.default
    private let nodeInteractor = PNINodeInteractor()
    init() {
        // Default
    }
    func pick(camera cameraNode: PNCameraNode,
              scene: PNScene,
              point: PNPoint2D) -> [PNScenePiece] {
        let inverseProjection = cameraNode.camera.projectionMatrixInverse
        var far = [0, 0, 1, 1] * inverseProjection
        var near = [0, 0, 0, 1] * inverseProjection
        far /= far.w
        near /= near.w
        let isPerspective = far.z == near.z
        let direction = inverseProjection * simd_float4(point.x, point.y, 1, 1)
        let origin = isPerspective ? .zero : simd_float3(direction.x, direction.y, 0)
        let rayEye = PNRay(origin: origin, direction: direction.xyz.normalized)
        let rayWorld = cameraNode.worldTransform.value * rayEye
        return nodeInteractor.deepSearch(from: scene.rootNode) { node in
            guard let value = node.data.worldBoundingBox.value else {
                return false
            }
            return boundInteractor.intersect(boundingBoxInteractor.bound(value), ray: rayWorld)
        }
    }
}
