//
//  Copyright © 2021 Mateusz Stompór. All rights reserved.
//

public protocol PNWorkloadManagerFactory {
    func new(bufferStore: BufferStore,
             renderingCoordinator: PNRenderingCoordinator,
             renderMaskGenerator: PNRenderMaskGenerator) -> PNWorkloadManager
}
