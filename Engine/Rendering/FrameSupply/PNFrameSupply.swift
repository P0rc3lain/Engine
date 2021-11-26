//
//  Copyright © 2021 Mateusz Stompór. All rights reserved.
//

public class PNFrameSupply {
    let scene: PNSceneDescription
    let bufferStore: BufferStore
    public init(scene: PNSceneDescription, bufferStore: BufferStore) {
        self.scene = scene
        self.bufferStore = bufferStore
    }
}
