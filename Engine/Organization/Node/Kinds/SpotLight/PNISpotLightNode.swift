//
//  Copyright © 2021 Mateusz Stompór. All rights reserved.
//

import MetalBinding

public final class PNISpotLightNode: PNSpotLightNode {
    public var light: PNSpotLight
    public let transform: PNSubject<PNLTransform>
    public let worldTransform: PNSubject<PNM2WTransform>
    public let enclosingNode: PNScenePieceSubject
    public let modelUniforms: PNSubject<WModelUniforms>
    private let refreshController = PNIRefreshController()
    public init(light: PNSpotLight,
                transform: PNLTransform) {
        self.light = light
        self.transform = PNSubject(transform)
        self.worldTransform = PNSubject(.identity)
        self.enclosingNode = PNSubject(PNWeakRef(nil))
        self.modelUniforms = PNSubject(.identity)
        self.refreshController.setup(self)
    }
    public func write(scene: PNSceneDescription, parentIdx: PNParentIndex) -> PNNewlyWrittenIndex {
        let entity = PNEntity(type: .spotLight, referenceIdx: scene.spotLights.count)
        scene.entities.add(parentIdx: parentIdx, data: entity)
        scene.spotLights.append(SpotLight.make(light: light,
                                               index: scene.entities.count - 1))
        return scene.entities.count - 1
    }
    public func update() {
        // Empty
    }
}
