//
//  Copyright © 2021 Mateusz Stompór. All rights reserved.
//

import Metal
import MetalBinding
import simd

struct BufferStore {
    var omniLights: DynamicBuffer<OmniLight>
    var ambientLights: DynamicBuffer<AmbientLight>
    var directionalLights: DynamicBuffer<DirectionalLight>
    var spotLights: DynamicBuffer<SpotLight>
    var cameras: DynamicBuffer<CameraUniforms>
    var modelCoordinateSystems: DynamicBuffer<ModelUniforms>
    var matrixPalettes: DynamicBuffer<simd_float4x4>
    init?(device: MTLDevice) {
        guard let omniLights = DynamicBuffer<OmniLight>(device: device, initialCapacity: 1),
              let cameras = DynamicBuffer<CameraUniforms>(device: device, initialCapacity: 1),
              let modelCoordinateSystems = DynamicBuffer<ModelUniforms>(device: device, initialCapacity: 1),
              let matrixPalettes = DynamicBuffer<simd_float4x4>(device: device, initialCapacity: 1),
              let ambientLights = DynamicBuffer<AmbientLight>(device: device, initialCapacity: 1),
              let directionalLights = DynamicBuffer<DirectionalLight>(device: device, initialCapacity: 1),
              let spotLights = DynamicBuffer<SpotLight>(device: device, initialCapacity: 1) else {
                  return nil
        }
        self.omniLights = omniLights
        self.ambientLights = ambientLights
        self.cameras = cameras
        self.modelCoordinateSystems = modelCoordinateSystems
        self.matrixPalettes = matrixPalettes
        self.directionalLights = directionalLights
        self.spotLights = spotLights
    }
    mutating func upload(camera: inout Camera, index: Int) {
        var uniforms = [CameraUniforms(projectionMatrix: camera.projectionMatrix, index: Int32(index))]
        cameras.upload(data: &uniforms)
    }

}
