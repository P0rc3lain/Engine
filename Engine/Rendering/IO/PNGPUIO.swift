//
//  Copyright © 2021 Mateusz Stompór. All rights reserved.
//

import Foundation

struct PNGPUIO {
    static var empty: PNGPUIO {
        PNGPUIO(input: .empty,
                output: .empty)
    }
    let input: PNGPUSupply
    let output: PNGPUSupply
}
