//
//  Copyright © 2021 Mateusz Stompór. All rights reserved.
//

public protocol PNTransformCalculator {
    func transformation(node: PNSceneNode,
                        parent: PNIndex,
                        scene: PNSceneDescription) -> PNM2WTransform
}
