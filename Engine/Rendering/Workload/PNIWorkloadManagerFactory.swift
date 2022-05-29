//
//  Copyright © 2021 Mateusz Stompór. All rights reserved.
//

public struct PNIWorkloadManagerFactory: PNWorkloadManagerFactory {
    public init() {}
    public func new(bufferStore: PNBufferStore,
                    renderingCoordinator: PNRenderingCoordinator,
                    renderMaskGenerator: PNRenderMaskGenerator) -> PNWorkloadManager {
        PNIWorkloadManager(bufferStore: bufferStore,
                           renderingCoordinator: renderingCoordinator,
                           renderMaskGenerator: renderMaskGenerator,
                           transcriber: PNITranscriber.default)
    }
}
