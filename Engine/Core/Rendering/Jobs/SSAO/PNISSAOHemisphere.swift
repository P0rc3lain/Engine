//
//  Copyright © 2021 Mateusz Stompór. All rights reserved.
//

import simd

struct PNISSAOHemisphere: PNSSAOHemisphere {
    private let minimalValue: Float = 0.001
    func noise(count: Int) -> [simd_float3] {
        var samples = [simd_float3]()
        for _ in count.exclusiveON {
            samples.append(noiseSample)
        }
        return samples
    }
    func samples(size: Int) -> [simd_float3] {
        var samples = [simd_float3]()
        for index in 0 ..< size {
            var vector = normalize(simd_float3(Float.random(in: 0 ..< 1) * 2 - 1,
                                               Float.random(in: 0 ..< 1) * 2 - 1,
                                               Float.random(in: 0 ..< 1)))
            vector *= Float.random(in: 0 ..< 1)
            let scale = Float(index / size)
            let scaleFactor = simd_mix(0.1, 1.0, scale * scale)
            vector *= scaleFactor
            samples.append(vector)
        }
        return samples
    }
    private var rawNoiseSample: simd_float3 {
        simd_float3(Float.random(in: 0 ..< 1) * 2 - 1,
                    Float.random(in: 0 ..< 1) * 2 - 1,
                    0)
    }
    private var noiseSample: simd_float3 {
        var candidate = rawNoiseSample
        while length(candidate) <= minimalValue {
            candidate = rawNoiseSample
        }
        return candidate
    }
}
