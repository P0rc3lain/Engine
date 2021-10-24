//
//  Copyright © 2021 Mateusz Stompór. All rights reserved.
//

import simd
import Metal
import MetalBinding

struct BufferStore {
    // MARK: - Properties
    var omniLights: DynamicBuffer<OmniLight>
    var cameras: DynamicBuffer<CameraUniforms>
    var modelCoordinateSystems: DynamicBuffer<ModelUniforms>
    var matrixPalettes: DynamicBuffer<simd_float4x4>
    // MARK: - Initialization
    init?(device: MTLDevice) {
        guard let omniLights = DynamicBuffer<OmniLight>(device: device, initialCapacity: 1),
              let cameras = DynamicBuffer<CameraUniforms>(device: device, initialCapacity: 1),
              let modelCoordinateSystems = DynamicBuffer<ModelUniforms>(device: device, initialCapacity: 1),
              let matrixPalettes = DynamicBuffer<simd_float4x4>(device: device, initialCapacity: 1) else {
                  return nil
        }
        self.omniLights = omniLights
        self.cameras = cameras
        self.modelCoordinateSystems = modelCoordinateSystems
        self.matrixPalettes = matrixPalettes
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
    mutating func upload(palettes: inout [simd_float4x4]) {
        matrixPalettes.upload(data: &palettes)
    }
}
