//
//  BufferStore.swift
//  Engine
//
//  Created by Mateusz Stompór on 15/11/2020.
//

import Metal
import MetalBinding

struct BufferStore {
    // MARK: - Properties
    var omniLights: DynamicBuffer<OmniLight>
    var cameras: DynamicBuffer<CameraUniforms>
    var modelCoordinateSystems: DynamicBuffer<ModelUniforms>
    // MARK: - Initialization
    init(device: MTLDevice) {
        omniLights = DynamicBuffer<OmniLight>(device: device, initialCapacity: 1)!
        cameras = DynamicBuffer<CameraUniforms>(device: device, initialCapacity: 1)!
        modelCoordinateSystems = DynamicBuffer<ModelUniforms>(device: device, initialCapacity: 1)!
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
