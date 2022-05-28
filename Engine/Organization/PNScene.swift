//
//  Copyright © 2021 Mateusz Stompór. All rights reserved.
//

import Metal
import simd

public struct PNScene {
    public let rootNode: PNNode<PNSceneNode>
    public var directionalLights: [PNDirectionalLight]
    public var environmentMap: MTLTexture?
    public init(rootNode: PNNode<PNSceneNode>,
                directionalLights: [PNDirectionalLight]) {
        self.rootNode = rootNode
        self.directionalLights = directionalLights
    }
    public static var `default`: PNScene {
        let groupNode = PNISceneNode(transform: matrix_identity_float4x4)
        return PNScene(rootNode: PNNode(data: groupNode),
                       directionalLights: [])
    }
}
