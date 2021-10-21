//
//  Data.swift
//  Engine
//
//  Created by Mateusz Stompór on 12/10/2021.
//

import simd

extension Data {
    public static func solid2DTexture(color: simd_float4) -> Data {
        assert(simd.length(color) <= 2.001, "Color values must be in [0.0, 1.0] range")
        let mapped = simd_uchar4(color.zyxw * 255)
        let values = Array<simd_uchar4>(repeating: mapped, count: 64)
        var data = Data(capacity: MemoryLayout<simd_uchar4>.size * values.count)
        values.withUnsafeBufferPointer { ptr in
            data.replaceSubrange(0 ..< data.count, with: ptr)
        }
        return data
    }
}
