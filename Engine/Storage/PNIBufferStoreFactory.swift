//
//  Copyright © 2022 Mateusz Stompór. All rights reserved.
//

import Metal

struct PNIBufferStoreFactory: PNBufferStoreFactory {
    private let device: MTLDevice
    init(device: MTLDevice) {
        self.device = device
    }
    func new() -> PNBufferStore? {
        PNIBufferStore(device: device)
    }
}
