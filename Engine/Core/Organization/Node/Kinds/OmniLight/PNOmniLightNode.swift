//
//  Copyright © 2021 Mateusz Stompór. All rights reserved.
//

/// A node containing single ``PNOmniLight``.
public protocol PNOmniLightNode: PNSceneNode {
    var light: PNOmniLight { get }
}
