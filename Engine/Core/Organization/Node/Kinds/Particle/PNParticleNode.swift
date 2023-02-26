//
//  Copyright © 2022 Mateusz Stompór. All rights reserved.
//

/// A node for storing particle system.
public protocol PNParticleNode: PNSceneNode {
    var provider: PNRenderableParticlesProvider { get }
}
