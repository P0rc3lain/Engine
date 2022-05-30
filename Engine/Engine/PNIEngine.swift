//
//  Copyright © 2021 Mateusz Stompór. All rights reserved.
//

import MetalKit

public final class PNIEngine: PNEngine {
    private let view: MTKView
    public var scene: PNScene
    private let renderMaskGenerator: PNRenderMaskGenerator
    private let coordinatorFactory: PNRenderingCoordinatorFactory
    private let workloadManagerFactory: PNWorkloadManagerFactory
    private var workloadManager: PNWorkloadManager
    private let bufferStoreFactory: PNBufferStoreFactory
    public init?(view: MTKView,
                 renderingSize: CGSize,
                 scene: PNScene,
                 coordinatorFactory: PNRenderingCoordinatorFactory,
                 workloadManagerFactory: PNWorkloadManagerFactory,
                 bufferStoreFactory: PNBufferStoreFactory,
                 renderMaskGenerator: PNRenderMaskGenerator) {
        guard let coordinator = coordinatorFactory.new(drawableSize: renderingSize),
              let workloadManager = workloadManagerFactory.new(bufferStoreFactory: bufferStoreFactory,
                                                               renderingCoordinator: coordinator,
                                                               renderMaskGenerator: renderMaskGenerator) else {
            assert(false, "Could not create coordinator")
            return nil
        }
        self.view = view
        self.bufferStoreFactory = bufferStoreFactory
        self.coordinatorFactory = coordinatorFactory
        self.scene = scene
        self.workloadManagerFactory = workloadManagerFactory
        self.workloadManager = workloadManager
        self.renderMaskGenerator = renderMaskGenerator
    }
    public func update(drawableSize: CGSize) -> Bool {
        guard let updated = coordinatorFactory.new(drawableSize: drawableSize),
              let workloadManager = workloadManagerFactory.new(bufferStoreFactory: bufferStoreFactory,
                                                               renderingCoordinator: updated,
                                                               renderMaskGenerator: renderMaskGenerator) else {
            return false
        }
        self.workloadManager = workloadManager
        return true
    }
    public func draw() {
        workloadManager.draw(sceneGraph: scene)
    }
    public static func `default`(view: MTKView,
                                 renderingSize: CGSize,
                                 scene: PNScene,
                                 threaded: Bool) -> PNIEngine? {
        guard let device = view.device else {
            return nil
        }
        let interactor = PNIBoundingBoxInteractor.default
        let cullingController = PNICullingController(interactor: interactor)
        let maskGenerator = PNIRenderMaskGenerator(cullingController: cullingController,
                                                   interactor: interactor)
        return PNIEngine(view: view,
                         renderingSize: renderingSize,
                         scene: scene,
                         coordinatorFactory: PNIRenderingCoordinatorFactory(view: view),
                         workloadManagerFactory: workloadManagerFactory(threaded: threaded),
                         bufferStoreFactory: PNIBufferStoreFactory(device: device),
                         renderMaskGenerator: maskGenerator)
    }
    static func workloadManagerFactory(threaded: Bool) -> PNWorkloadManagerFactory {
        if threaded {
            return PNIThreadedWorkloadManagerFactory()
        } else {
            return PNIWorkloadManagerFactory()
        }
    }
}
