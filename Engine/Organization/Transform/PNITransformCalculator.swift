//
//  Copyright © 2021 Mateusz Stompór. All rights reserved.
//

import simd

struct PNITransformCalculator: PNTransformCalculator {
    let interpolator: PNInterpolator
    init(interpolator: PNInterpolator) {
        self.interpolator = interpolator
    }
    func transformation(node: PNSceneNode, parent: PNIndex, scene: PNSceneDescription) -> PNM2WTransform {
        parent != .nil ? (scene.uniforms[parent].modelMatrix * node.transform) : node.transform
    }
}
