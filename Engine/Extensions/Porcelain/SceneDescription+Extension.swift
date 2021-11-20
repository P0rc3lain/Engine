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
        // MARK: - Capacity C
        description.meshes = meshes.compactMap { $0.upload(device: device) }
        description.meshBoundingBoxes = meshBoundingBoxes
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
        description.omniLightNames = omniLightNames
        description.omniLights = omniLights
        // MARK: - Capacity I
        description.ambientLightNames = ambientLightNames
        description.ambientLights = ambientLights
        // MARK: - Capacity J
        description.directionalLightNames = directionalLightNames
        description.directionalLights = directionalLights
        // MARK: - Capacity K
        description.spotLightNames = spotLightNames
        description.spotLights = spotLights
        // MARK: - Capacity L
        description.skyMaps = skyMaps.compactMap { $0.upload(device: device) }
        // MARK: - Capacity M
        description.activeCameraIdx = activeCameraIdx
        description.sky = sky
        guard description.skyMaps.count == skyMaps.count,
              description.meshes.count == meshes.count else {
            return nil
        }
        return description
    }
}
