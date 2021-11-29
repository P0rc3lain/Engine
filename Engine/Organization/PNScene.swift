//
//  Copyright © 2021 Mateusz Stompór. All rights reserved.
//

import simd

public struct PNScene {
    public let rootNode: PNNode<PNSceneNode>
    public var directionalLights: [PNDirectionalLight]
    public init(rootNode: PNNode<PNSceneNode>, directionalLights: [PNDirectionalLight]) {
        self.rootNode = rootNode
        self.directionalLights = directionalLights
    }
    public static var `default`: PNScene {
        PNScene(rootNode: PNNode(data: PNISceneNode(transform: matrix_identity_float4x4)),
                directionalLights: [])
    }
}
