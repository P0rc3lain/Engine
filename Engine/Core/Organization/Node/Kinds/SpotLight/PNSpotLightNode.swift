//
//  Copyright © 2021 Mateusz Stompór. All rights reserved.
//

/// A node containing single ``PNSpotLight``.
public protocol PNSpotLightNode: PNSceneNode {
    var light: PNSpotLight { get }
}
