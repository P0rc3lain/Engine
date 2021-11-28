//
//  Copyright © 2021 Mateusz Stompór. All rights reserved.
//

public class PNFrameSupply {
    let scene: PNSceneDescription
    let bufferStore: PNBufferStore
    let mask: PNRenderMask
    public init(scene: PNSceneDescription,
                bufferStore: PNBufferStore,
                mask: PNRenderMask) {
        self.scene = scene
        self.bufferStore = bufferStore
        self.mask = mask
    }
}
