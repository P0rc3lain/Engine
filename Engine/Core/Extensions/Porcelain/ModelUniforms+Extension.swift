//
//  Copyright © 2021 Mateusz Stompór. All rights reserved.
//

import PNShared

extension ModelUniforms: @retroactive Equatable {
    public static func == (lhs: Self, rhs: Self) -> Bool {
        lhs.modelMatrixInverse == rhs.modelMatrixInverse &&
        lhs.modelMatrix == rhs.modelMatrix
    }
    static func from(transform: PNTransform) -> ModelUniforms {
        ModelUniforms(modelMatrix: transform, modelMatrixInverse: transform.inverse)
    }
    static var identity: ModelUniforms {
        ModelUniforms(modelMatrix: .identity,
                      modelMatrixInverse: .identity)
    }
}
