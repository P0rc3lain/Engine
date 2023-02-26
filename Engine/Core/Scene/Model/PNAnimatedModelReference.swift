//
//  Copyright © 2021 Mateusz Stompór. All rights reserved.
//

/// Associated data about mesh, skeleeton and an entity in ``PNEntityTree``.
public struct PNAnimatedModelReference {
    let skeleton: PNIndex
    let mesh: PNIndex
    let idx: PNIndex
}
