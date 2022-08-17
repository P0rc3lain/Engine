//
//  Copyright © 2021 Mateusz Stompór. All rights reserved.
//

import simd

struct PNITransformCalculator: PNTransformCalculator {
    private let interpolator: PNInterpolator
    init(interpolator: PNInterpolator) {
        self.interpolator = interpolator
    }
    func transformation(node: PNSceneNode, parent: PNIndex, scene: PNSceneDescription) -> PNM2WTransform {
        let transform = node.transform.value
        return parent != .nil ? scene.uniforms[parent].modelMatrix * transform : transform
    }
}
