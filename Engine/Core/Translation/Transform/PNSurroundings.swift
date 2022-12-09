//
//  Copyright © 2022 Mateusz Stompór. All rights reserved.
//

import simd

struct PNSurroundings {
    private init() {
        // empty, no need for instantiation
    }
    // Quaternions
    static let positiveXq = simd_quatf(angle: Float(180).radians,
                                       axis: [0, 0, 1]) * simd_quatf(angle: Float(-90).radians, axis: [0, 1, 0])
    static let negativeXq = simd_quatf(angle: Float(180).radians,
                                       axis: [0, 0, 1]) * simd_quatf(angle: Float(90).radians, axis: [0, 1, 0])
    static let positiveYq = simd_quatf(angle: Float(90).radians,
                                       axis: [1, 0, 0]) * simd_quatf(angle: Float(-180).radians, axis: [0, 0, 1])
    static let negativeYq = simd_quatf(angle: Float(-90).radians,
                                       axis: [1, 0, 0]) * simd_quatf(angle: Float(-180).radians, axis: [0, 0, 1])
    static let positiveZq = simd_quatf(angle: Float(180).radians,
                                       axis: [0, 0, 1])
    static let negativeZq = simd_quatf(angle: Float(180).radians,
                                       axis: [0, 0, 1]) * simd_quatf(angle: Float(180).radians, axis: [0, 1, 0])
    // Matrices
    static let positiveX = positiveXq.rotationMatrix
    static let negativeX = negativeXq.rotationMatrix
    static let positiveY = positiveYq.rotationMatrix
    static let negativeY = negativeYq.rotationMatrix
    static let positiveZ = positiveZq.rotationMatrix
    static let negativeZ = negativeZq.rotationMatrix
    static subscript(index: Int) -> simd_float4x4 {
        switch index {
        case 0:
            return positiveX
        case 1:
            return negativeX
        case 2:
            return positiveY
        case 3:
            return negativeY
        case 4:
            return positiveZ
        case 5:
            return negativeZ
        default:
            fatalError("Index out of bounds")
        }
    }
    static let rotationMatrices = [
        positiveX,
        negativeX,
        negativeY,
        positiveY,
        positiveZ,
        negativeZ
    ]
}
