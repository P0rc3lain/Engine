//
//  Copyright © 2021 Mateusz Stompór. All rights reserved.
//

import simd

extension simd_quatf {
    struct Environment {
        // TODO: Change it to a struct containing array
        let positiveX: simd_quatf
        let negativeX: simd_quatf
        let positiveY: simd_quatf
        let negativeY: simd_quatf
        let positiveZ: simd_quatf
        let negativeZ: simd_quatf
        public subscript(index: Int) -> simd_quatf {
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
