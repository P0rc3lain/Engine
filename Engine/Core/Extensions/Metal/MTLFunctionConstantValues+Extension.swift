//
//  Copyright © 2021 Mateusz Stompór. All rights reserved.
//

import Metal
import simd

extension MTLFunctionConstantValues {
    fileprivate static var clean: MTLFunctionConstantValues {
        MTLFunctionConstantValues()
    }
    // bool
    static func bool<T: RawRepresentable>(_ value: Bool, index: T) -> MTLFunctionConstantValues where T.RawValue == UInt32 {
        .clean.bool(value, index: index)
    }
    func bool<T: RawRepresentable>(_ value: Bool, index: T) -> MTLFunctionConstantValues where T.RawValue == UInt32 {
        var modifiableValue = value
        setConstantValue(&modifiableValue,
                         type: .bool,
                         index: index.int)
        return self
    }
    // int
    static func int<T: RawRepresentable>(_ value: Int, index: T) -> MTLFunctionConstantValues where T.RawValue == UInt32 {
        .clean.int(value, index: index)
    }
    func int<T: RawRepresentable>(_ value: Int, index: T) -> MTLFunctionConstantValues where T.RawValue == UInt32 {
        var modifiableValue = value
        setConstantValue(&modifiableValue,
                         type: .int,
                         index: index.int)
        return self
    }
    // int2
    static func int2<T: RawRepresentable>(_ value: simd_int2, index: T) -> MTLFunctionConstantValues where T.RawValue == UInt32 {
        .clean.int2(value, index: index)
    }
    func int2<T: RawRepresentable>(_ value: simd_int2, index: T) -> MTLFunctionConstantValues where T.RawValue == UInt32 {
        var modifiableValue = value
        setConstantValue(&modifiableValue,
                         type: .int2,
                         index: index.int)
        return self
    }
    // int3
    static func int3<T: RawRepresentable>(_ value: simd_int3, index: T) -> MTLFunctionConstantValues where T.RawValue == UInt32 {
        .clean.int3(value, index: index)
    }
    func int3<T: RawRepresentable>(_ value: simd_int3, index: T) -> MTLFunctionConstantValues where T.RawValue == UInt32 {
        var modifiableValue = value
        setConstantValue(&modifiableValue,
                         type: .int3,
                         index: index.int)
        return self
    }
    // float2
    static func float2<T: RawRepresentable>(_ value: simd_float2, index: T) -> MTLFunctionConstantValues where T.RawValue == UInt32 {
        .clean.float2(value, index: index)
    }
    func float2<T: RawRepresentable>(_ value: simd_float2, index: T) -> MTLFunctionConstantValues where T.RawValue == UInt32 {
        var modifiableValue = value
        setConstantValue(&modifiableValue,
                         type: .float2,
                         index: index.int)
        return self
    }
    // float
    static func float<T: RawRepresentable>(_ value: Float, index: T) -> MTLFunctionConstantValues where T.RawValue == UInt32 {
        .clean.float(value, index: index)
    }
    func float<T: RawRepresentable>(_ value: Float, index: T) -> MTLFunctionConstantValues where T.RawValue == UInt32 {
        var modifiableValue = value
        setConstantValue(&modifiableValue,
                         type: .float,
                         index: index.int)
        return self
    }
}
