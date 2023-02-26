//
//  Copyright © 2021 Mateusz Stompór. All rights reserved.
//

/// A node for storing rigid body model of ``PNMesh`` class.
public protocol PNMeshNode: PNSceneNode {
    var mesh: PNMesh { get }
}
