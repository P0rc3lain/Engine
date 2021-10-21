//
//  BufferStore.swift
//  Engine
//
//  Created by Mateusz Stompór on 15/11/2020.
//

import simd
import Metal
import MetalBinding

struct BufferStore {
    // MARK: - Properties
    var omniLights: DynamicBuffer<OmniLight>
    var cameras: DynamicBuffer<CameraUniforms>
    var modelCoordinateSystems: DynamicBuffer<ModelUniforms>
    // MARK: - Initialization
    init?(device: MTLDevice) {
        guard let omniLights = DynamicBuffer<OmniLight>(device: device, initialCapacity: 1),
              let cameras = DynamicBuffer<CameraUniforms>(device: device, initialCapacity: 1),
              let modelCoordinateSystems = DynamicBuffer<ModelUniforms>(device: device, initialCapacity: 1) else {
                  return nil
        }
        self.omniLights = omniLights
        self.cameras = cameras
        self.modelCoordinateSystems = modelCoordinateSystems
    }
    mutating func upload(camera: inout Camera, transform: inout TransformAnimation) {
        let viewMatrix = transform.transformation(at: 0)
        var uniforms = [CameraUniforms(projectionMatrix: camera.projectionMatrix, viewMatrix: viewMatrix, viewMatrixInverse: viewMatrix.inverse)]
        cameras.upload(data: &uniforms)
    }
    mutating func upload(models: inout EntityTree) {
        var uniforms = models.modelUniforms
        modelCoordinateSystems.upload(data: &uniforms)
    }
}
