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
        description.objectNames = objectNames
        description.objects = objects
        description.materialNames = materialNames
        description.materials = materials.compactMap{ $0.upload(device: device) }
        description.meshNames = meshNames
        description.meshes = meshes.compactMap{ $0.upload(device: device) }
        description.skeletonReferences = skeletonReferences
        description.skeletons = skeletons
        description.skeletalAnimations = skeletalAnimations
        description.cameraNames = cameraNames
        description.cameras = cameras
        guard description.materials.count == materials.count,
              description.meshes.count == meshes.count else {
            return nil
        }
        return description
    }
}
