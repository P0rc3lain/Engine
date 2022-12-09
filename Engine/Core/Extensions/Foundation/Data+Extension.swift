//
//  Copyright © 2021 Mateusz Stompór. All rights reserved.
//

import simd

extension Data {
    public static func solid2DTexture(color: PNColor4) -> Data {
        assertValid(color: color)
        let mapped = simd_uchar4(color.zyxw * 255)
        let values = [simd_uchar4](repeating: mapped, count: 64)
        var data = Data(capacity: MemoryLayout<simd_uchar4>.size * values.count)
        values.withUnsafeBufferPointer { pointer in
            data.replaceSubrange(data.indices, with: pointer)
        }
        return data
    }
}
