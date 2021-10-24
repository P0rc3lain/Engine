//
//  Extension+Material.swift
//  Engine
//
//  Created by Mateusz Stompór on 15/10/2021.
//

import Metal

extension RamMaterial {
    func upload(device: MTLDevice) -> GPUMaterial? {
        guard let albedo = albedo.upload(device: device),
              let normals = normals.upload(device: device),
              let metallic = metallic.upload(device: device),
              let roughness = roughness.upload(device: device) else {
            return nil
        }
        return GPUMaterial(albedo: albedo,
                           roughness: roughness,
                           normals: normals,
                           metallic: metallic)
    }
}
