//
//  Copyright © 2021 Mateusz Stompór. All rights reserved.
//

/// A node containing description of ``PNAmbientLight`` influence.
public protocol PNAmbientLightNode: PNSceneNode {
    var light: PNAmbientLight { get }
}
