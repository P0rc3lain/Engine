//
//  Copyright © 2021 Mateusz Stompór. All rights reserved.
//

import MetalBinding

extension ModelUniforms: Equatable {
    public static func == (lhs: Self, rhs: Self) -> Bool {
        lhs.modelMatrixInverse == rhs.modelMatrixInverse &&
        lhs.modelMatrix == rhs.modelMatrix
    }
    static func from(transform: Transform) -> ModelUniforms {
        ModelUniforms(modelMatrix: transform, modelMatrixInverse: transform.inverse)
    }
}
