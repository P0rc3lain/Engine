//
//  Copyright © 2021 Mateusz Stompór. All rights reserved.
//

public struct PNIWorkloadManagerFactory: PNWorkloadManagerFactory {
    public init() {}
    public func new(bufferStoreFactory: PNBufferStoreFactory,
                    renderingCoordinator: PNRenderingCoordinator,
                    renderMaskGenerator: PNRenderMaskGenerator) -> PNWorkloadManager? {
        guard let bufferStore = bufferStoreFactory.new() else {
            return nil
        }
        return PNIWorkloadManager(bufferStore: bufferStore,
                                  renderingCoordinator: renderingCoordinator,
                                  renderMaskGenerator: renderMaskGenerator,
                                  transcriber: PNITranscriber.default)
    }
}
