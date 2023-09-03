//
//  Copyright © 2021 Mateusz Stompór. All rights reserved.
//

import Combine
import PNShared

public final class PNIAmbientLightNode: PNAmbientLightNode {
    public let name: String
    public let light: PNAmbientLight
    public let transform: PNSubject<PNLTransform>
    public let worldTransform: PNSubject<PNM2WTransform>
    public let enclosingNode: PNScenePieceSubject
    public let modelUniforms: PNSubject<PNWModelUniforms>
    public let localBoundingBox: PNSubject<PNBoundingBox?>
    public let worldBoundingBox: PNSubject<PNBoundingBox?>
    public let childrenMergedBoundingBox: PNSubject<PNBoundingBox?>
    public let intrinsicBoundingBox: PNBoundingBox?
    private let refreshController = PNIRefreshController()
    public init(light: PNAmbientLight,
                transform: PNLTransform,
                name: String = "") {
        self.name = name
        self.light = light
        self.transform = PNSubject(transform)
        self.worldTransform = PNSubject(.identity)
        self.enclosingNode = PNSubject(PNWeakRef(nil))
        self.modelUniforms = PNSubject(.identity)
        self.localBoundingBox = PNSubject(nil)
        self.worldBoundingBox = PNSubject(nil)
        self.childrenMergedBoundingBox = PNSubject(nil)
        self.intrinsicBoundingBox = light.boundingBox
        self.refreshController.setup(self)
    }
    public func write(scene: PNSceneDescription, parentIdx: PNParentIndex) -> PNNewlyWrittenIndex {
        let entity = PNEntity(type: .ambientLight,
                              referenceIdx: scene.ambientLights.count)
        scene.entities.add(parentIdx: parentIdx, data: entity)
        let underlyinglight = AmbientLight(diameter: light.diameter,
                                           color: light.color,
                                           intensity: light.intensity,
                                           idx: Int32(scene.entities.count - 1))
        scene.ambientLights.append(underlyinglight)
        return scene.entities.count - 1
    }
    public func update() {
        // Empty
    }
}
