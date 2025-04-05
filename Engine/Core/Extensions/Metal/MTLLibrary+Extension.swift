//
//  Copyright © 2022 Mateusz Stompór. All rights reserved.
//

import Metal

extension MTLLibrary {
    func failOrMakeFunction(name functionName: String) -> any MTLFunction {
        guard let function = makeFunction(name: functionName) else {
            fatalError("Could not create function with name: \(functionName)")
        }
        return function
    }
    func failOrMakeFunction(name: String, constantValues: MTLFunctionConstantValues) -> any MTLFunction {
        do {
            return try makeFunction(name: name, constantValues: constantValues)
        } catch let error {
            fatalError("Could not create function with name: \(name), error: \(error.localizedDescription)")
        }
    }
    func labeled(_ label: String) -> MTLLibrary {
        self.label = label
        return self
    }
}
