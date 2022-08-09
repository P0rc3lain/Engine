//
//  Copyright © 2022 Mateusz Stompór. All rights reserved.
//

func validate(scene: PNSceneDescription) -> Bool {
    let entityReferences = cmp(scene.entities.count,
                               scene.uniforms.count,
                               scene.boundingBoxes.count)
    let paletteReferences = cmp(scene.animatedModels.count,
                                scene.paletteOffset.count)
    let cameraReferences = cmp(scene.cameras.count,
                               scene.cameraUniforms.count)
    return entityReferences && paletteReferences && cameraReferences
}
