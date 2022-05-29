//
//  Copyright © 2021 Mateusz Stompór. All rights reserved.
//

public protocol PNWorkloadManagerFactory {
    func new(bufferStoreFactory: PNBufferStoreFactory,
             renderingCoordinator: PNRenderingCoordinator,
             renderMaskGenerator: PNRenderMaskGenerator) -> PNWorkloadManager?
}
