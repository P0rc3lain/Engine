//
//  Copyright © 2021 Mateusz Stompór. All rights reserved.
//

public protocol PNWorkloadManagerFactory {
    func new(bufferStore: PNBufferStore,
             renderingCoordinator: PNRenderingCoordinator,
             renderMaskGenerator: PNRenderMaskGenerator) -> PNWorkloadManager
}
