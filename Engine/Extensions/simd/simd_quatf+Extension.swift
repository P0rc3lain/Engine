//
//  Copyright © 2021 Mateusz Stompór. All rights reserved.
//

import simd

extension simd_quatf {
    struct Environment {
        let positiveX: simd_quatf
        let negativeX: simd_quatf
        let positiveY: simd_quatf
        let negativeY: simd_quatf
        let positiveZ: simd_quatf
        let negativeZ: simd_quatf
    }
    static var environment: Environment {
        let xPlus = simd_quatf(angle: Float(180).radians, axis: [0, 0, 1]) * simd_quatf(angle: Float(-90).radians, axis: [0, 1, 0])
        let xMinus = simd_quatf(angle: Float(180).radians, axis: [0, 0, 1]) * simd_quatf(angle: Float(90).radians, axis: [0, 1, 0])
        let yPlus = simd_quatf(angle: Float(90).radians, axis: [1, 0, 0]) * simd_quatf(angle: Float(-180).radians, axis: [0, 0, 1])
        let yMinus = simd_quatf(angle: Float(-90).radians, axis: [1, 0, 0]) * simd_quatf(angle: Float(-180).radians, axis: [0, 0, 1])
        let zPlus = simd_quatf(angle: Float(180).radians, axis: [0, 0, 1])
        let zMinus = simd_quatf(angle: Float(180).radians, axis: [0, 0, 1]) * simd_quatf(angle: Float(180).radians, axis: [0, 1, 0])
        return Environment(positiveX: xPlus, negativeX: xMinus, positiveY: yPlus, negativeY: yMinus, positiveZ: zPlus, negativeZ: zMinus)
    }
    var rotationMatrix: simd_float4x4 {
        simd_float4x4(self)
    }
}
