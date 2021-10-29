//
//  Copyright © 2021 Mateusz Stompór. All rights reserved.
//

import Metal

extension RamSceneDescription {
    func upload(device: MTLDevice) -> GPUSceneDescription? {
        var description = GPUSceneDescription()
        // MARK: - Capacity A
        description.entityNames = entityNames
        description.entities = entities
        description.skeletonReferences = skeletonReferences
        // MARK: - Capacity B
        description.materialNames = materialNames
        description.materials = materials.compactMap { $0.upload(device: device) }
        // MARK: - Capacity C
        description.meshNames = meshNames
        description.meshBuffers = meshBuffers.compactMap { $0.upload(device: device) }
        description.indexDrawReferences = indexDrawReferences
        // MARK: - Capacity D
        description.indexDrawsMaterials = indexDrawsMaterials
        description.indexDraws = indexDraws.compactMap { $0.upload(device: device) }
        // MARK: - Capacity E
        description.skeletons = skeletons
        description.paletteReferences = paletteReferences
        description.animationReferences = animationReferences
        // MARK: - Capacity F
        description.skeletalAnimations = skeletalAnimations
        // MARK: - Capacity G
        description.cameraNames = cameraNames
        description.cameras = cameras
        // MARK: - Capacity H
        description.lightNames = lightNames
        description.lights = lights
        // MARK: - Capacity I
        description.skyMaps = skyMaps.compactMap { $0.upload(device: device) }
        // MARK: - Capacity J
        description.activeCameraIdx = activeCameraIdx
        description.sky = sky
        guard description.materials.count == materials.count,
              description.skyMaps.count == skyMaps.count else {
            return nil
        }
        return description
    }
}
