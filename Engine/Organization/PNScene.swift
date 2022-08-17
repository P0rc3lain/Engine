//
//  Copyright © 2021 Mateusz Stompór. All rights reserved.
//

import Metal
import simd

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
        return PNScene(rootNode: PNNode(data: groupNode),
                       directionalLights: [])
    }
}
