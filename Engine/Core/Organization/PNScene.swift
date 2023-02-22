//
//  Copyright © 2021 Mateusz Stompór. All rights reserved.
//

import Metal
import simd

/// A component organising all entities that can be displayed on the screen.
public class PNScene {
    public let rootNode: PNScenePiece
    public var directionalLights: [PNDirectionalLight]
    public var environmentMap: MTLTexture?
    public init(rootNode: PNScenePiece,
                directionalLights: [PNDirectionalLight]) {
        self.rootNode = rootNode
        self.directionalLights = directionalLights
    }
    public static var `default`: PNScene {
        let groupNode = PNISceneNode(transform: .identity)
        return PNScene(rootNode: PNScenePiece.make(data: groupNode),
                       directionalLights: [])
    }
}
