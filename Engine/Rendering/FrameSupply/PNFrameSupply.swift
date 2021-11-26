//
//  Copyright © 2021 Mateusz Stompór. All rights reserved.
//

public class PNFrameSupply {
    let scene: PNSceneDescription
    let bufferStore: BufferStore
    let mask: PNRenderMask
    public init(scene: PNSceneDescription, bufferStore: BufferStore, mask: PNRenderMask) {
        self.scene = scene
        self.bufferStore = bufferStore
        self.mask = mask
    }
}
