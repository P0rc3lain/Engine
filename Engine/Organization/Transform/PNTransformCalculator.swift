//
//  Copyright © 2021 Mateusz Stompór. All rights reserved.
//

protocol PNTransformCalculator {
    func transformation(node: PNSceneNode, parent: PNIndex, scene: PNSceneDescription) -> PNM2WTransform
}
