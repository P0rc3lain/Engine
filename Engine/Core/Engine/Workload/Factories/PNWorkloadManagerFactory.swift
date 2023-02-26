//
//  Copyright © 2021 Mateusz Stompór. All rights reserved.
//

/// Produces a new instance of ``PNWorkloadManager`` when the configuration changes.
public protocol PNWorkloadManagerFactory {
    func new(bufferStoreFactory: PNBufferStoreFactory,
             renderingCoordinator: PNRenderingCoordinator,
             renderMaskGenerator: PNRenderMaskGenerator) -> PNWorkloadManager?
}
