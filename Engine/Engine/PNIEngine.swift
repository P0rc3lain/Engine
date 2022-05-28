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
    private var bufferStore: PNBufferStore
    public init?(view: MTKView,
                 renderingSize: CGSize,
                 scene: PNScene,
                 coordinatorFactory: PNRenderingCoordinatorFactory,
                 workloadManagerFactory: PNWorkloadManagerFactory,
                 renderMaskGenerator: PNRenderMaskGenerator) {
        guard let coordinator = coordinatorFactory.new(drawableSize: renderingSize),
              let device = view.device,
              let bufferStore = PNIBufferStore(device: device) else {
            assert(false, "Could not create coordinator")
            return nil
        }
        self.view = view
        self.coordinatorFactory = coordinatorFactory
        self.scene = scene
        self.bufferStore = bufferStore
        self.workloadManagerFactory = workloadManagerFactory
        self.renderMaskGenerator = renderMaskGenerator
        self.workloadManager = workloadManagerFactory.new(bufferStore: bufferStore,
                                                          renderingCoordinator: coordinator,
                                                          renderMaskGenerator: renderMaskGenerator)
    }
    public func update(drawableSize: CGSize) -> Bool {
        guard let updated = coordinatorFactory.new(drawableSize: drawableSize) else {
            return false
        }
        workloadManager = workloadManagerFactory.new(bufferStore: bufferStore,
                                                     renderingCoordinator: updated,
                                                     renderMaskGenerator: renderMaskGenerator)
        return true
    }
    public func draw() {
        workloadManager.draw(sceneGraph: &scene)
    }
    public static func `default`(view: MTKView,
                                 renderingSize: CGSize,
                                 scene: PNScene) -> PNIEngine? {
        let interactor = PNIBoundingBoxInteractor.default
        let cullingController = PNICullingController(interactor: interactor)
        let maskGenerator = PNIRenderMaskGenerator(cullingController: cullingController,
                                                   interactor: interactor)
        return PNIEngine(view: view,
                         renderingSize: renderingSize,
                         scene: scene,
                         coordinatorFactory: PNIRenderingCoordinatorFactory(view: view),
                         workloadManagerFactory: PNIWorkloadManagerFactory(),
                         renderMaskGenerator: maskGenerator)
    }
}
