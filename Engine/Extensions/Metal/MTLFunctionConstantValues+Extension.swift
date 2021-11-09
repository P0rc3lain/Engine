//
//  Copyright © 2021 Mateusz Stompór. All rights reserved.
//

import Metal

extension MTLFunctionConstantValues {
    static func `bool`(_ value: Bool, index: Int) -> MTLFunctionConstantValues {
        let constantValues = MTLFunctionConstantValues()
        var modifiableValue = value
        constantValues.setConstantValue(&modifiableValue,
                                        type: .bool,
                                        index: index)
        return constantValues
    }
}
