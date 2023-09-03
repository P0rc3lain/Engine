//
//  Copyright © 2023 Mateusz Stompór. All rights reserved.
//

import simd

/// Matrix that provides cached inverse for fast subsequent access
public class PNMatrix4x4FI {
    private var matrix: simd_float4x4?
    private var matrixInverse: simd_float4x4?
    public var mat: simd_float4x4 {
        get {
            if let m = matrix {
                return m
            } else if let inv = matrixInverse?.inverse {
                matrix = inv
                return inv
            } else {
                fatalError("Invalid state. Matrix not stored nor its inverse")
            }
        } set {
            matrix = newValue
            matrixInverse = nil
        }
    }
    public var inv: simd_float4x4 {
        get {
            if let m = matrixInverse {
                return m
            } else if let inv = matrix?.inverse {
                matrixInverse = inv
                return inv
            } else {
                fatalError("Invalid state. Matrix not stored nor its inverse")
            }
        } set {
            matrixInverse = newValue
            matrix = nil
        }
    }
    public init(_ matrix: simd_float4x4) {
        self.matrix = matrix
    }
    static func from(_ matrix: simd_float4x4) -> PNMatrix4x4FI {
        PNMatrix4x4FI(matrix)
    }
}
