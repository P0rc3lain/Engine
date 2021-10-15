//
//  BufferStore.swift
//  Engine
//
//  Created by Mateusz Stompór on 15/11/2020.
//

import Metal
import ShaderTypes

struct BufferStore {
    // MARK: - Properties
    var omniLights: DynamicBuffer<OmniLight>
    var cameras: DynamicBuffer<CameraUniforms>
    var modelCoordinateSystems: DynamicBuffer<ModelUniforms>
    // MARK: - Initialization
    init(device: MTLDevice) {
        omniLights = DynamicBuffer<OmniLight>(device: device, initialCapacity: 10)!
        cameras = DynamicBuffer<CameraUniforms>(device: device, initialCapacity: 1)!
        modelCoordinateSystems = DynamicBuffer<ModelUniforms>(device: device, initialCapacity: 10)!
    }
    mutating func upload(camera: inout Camera, transform: inout Transform) {
        let viewMatrix = transform.coordinateSpace.transformationRTS
        var uniforms = [CameraUniforms(projectionMatrix: camera.projectionMatrix, viewMatrix: viewMatrix, viewMatrixInverse: viewMatrix.inverse)]
        cameras.upload(data: &uniforms)
    }
    mutating func upload(models: inout [Transform]) {
        var allPieces = [ModelUniforms]()
        for i in 0..<models.count {
            let matrix = models[i].coordinateSpace.transformationTRS
            allPieces.append(ModelUniforms(modelMatrix: matrix, modelMatrixInverse: matrix.inverse, modelMatrixInverse2: matrix, modelMatrixInverse3: matrix))
        }
        modelCoordinateSystems.upload(data: &allPieces)
    }
}
