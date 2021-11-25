//
//  Copyright © 2021 Mateusz Stompór. All rights reserved.
//

import simd

struct PNITransformCalculator: PNTransformCalculator {
    let interpolator: PNInterpolator
    init(interpolator: PNInterpolator) {
        self.interpolator = interpolator
    }
    func transformation(node: PNSceneNode, parent: PNIndex, scene: inout PNSceneDescription) -> M2WTransform {
        let transform = node.transform.transformation(at: Date().timeIntervalSince1970, interpolator: interpolator)
        return parent != .nil ? (scene.uniforms[parent].modelMatrix * transform) : transform
    }
}
