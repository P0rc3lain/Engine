//
//  Copyright © 2021 Mateusz Stompór. All rights reserved.
//

public protocol PNRenderingCoordinator {
    mutating func draw(scene: inout PNSceneDescription, bufferStore: inout BufferStore)
}
