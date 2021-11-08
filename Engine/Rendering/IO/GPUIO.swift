//
//  Copyright © 2021 Mateusz Stompór. All rights reserved.
//

import Foundation

struct GPUIO {
    static var empty: GPUIO {
        GPUIO(input: .empty, output: .empty)
    }
    let input: GPUSupply
    let output: GPUSupply
}
