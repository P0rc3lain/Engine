//
//  Copyright © 2021 Mateusz Stompór. All rights reserved.
//

public struct PNIWorkloadManagerFactory: PNWorkloadManagerFactory {
    public init() {}
    public func new(bufferStore: BufferStore, renderingCoordinator: PNRenderingCoordinator) -> PNWorkloadManager {
        PNIWorkloadManager(bufferStore: bufferStore, renderingCoordinator: renderingCoordinator)
    }
}
