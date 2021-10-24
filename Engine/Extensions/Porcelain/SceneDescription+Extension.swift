//
//  SceneDescription.swift
//  Engine
//
//  Created by Mateusz Stompór on 15/10/2021.
//

import Metal

extension RamSceneDescription {
    func upload(device: MTLDevice) -> GPUSceneDescription? {
        var description = GPUSceneDescription()
        // MARK: - Capacity A
        description.objectNames = objectNames
        description.objects = objects
        description.skeletonReferences = skeletonReferences
        // MARK: - Capacity B
        description.materialNames = materialNames
        description.materials = materials.compactMap{ $0.upload(device: device) }
        // MARK: - Capacity C
        description.meshNames = meshNames
        description.meshes = meshes.compactMap{ $0.upload(device: device) }
        // MARK: - Capacity D
        description.skeletons = skeletons
        description.paletteReferences = paletteReferences
        description.animationReferences = animationReferences
        // MARK: - Capacity E
        description.skeletalAnimations = skeletalAnimations
        // MARK: - Capacity F
        description.cameraNames = cameraNames
        description.cameras = cameras
        // MARK: - Capacity G
        description.lightNames = lightNames
        description.lights = lights
        // MARK: - Capacity H
        description.skyMaps = skyMaps.compactMap { $0.upload(device: device) }
        // MARK: - Capacity I
        description.activeCameraIdx = activeCameraIdx
        description.sky = sky
        guard description.materials.count == materials.count,
              description.meshes.count == meshes.count,
              description.skyMaps.count == skyMaps.count else {
            return nil
        }
        return description
    }
}
