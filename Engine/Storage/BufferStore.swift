//
//  Copyright © 2021 Mateusz Stompór. All rights reserved.
//

import Metal
import MetalBinding
import simd

public struct BufferStore {
    var omniLights: PNAnyDynamicBuffer<OmniLight>
    var ambientLights: PNAnyDynamicBuffer<AmbientLight>
    var directionalLights: PNAnyDynamicBuffer<DirectionalLight>
    var spotLights: PNAnyDynamicBuffer<SpotLight>
    var cameras: PNAnyDynamicBuffer<CameraUniforms>
    var modelCoordinateSystems: PNAnyDynamicBuffer<ModelUniforms>
    var matrixPalettes: PNAnyDynamicBuffer<simd_float4x4>
    init?(device: MTLDevice) {
        guard let omniLights = PNIDynamicBuffer<OmniLight>(device: device, initialCapacity: 1),
              let cameras = PNIDynamicBuffer<CameraUniforms>(device: device, initialCapacity: 1),
              let modelCoordinateSystems = PNIDynamicBuffer<ModelUniforms>(device: device, initialCapacity: 1),
              let matrixPalettes = PNIDynamicBuffer<simd_float4x4>(device: device, initialCapacity: 1),
              let ambientLights = PNIDynamicBuffer<AmbientLight>(device: device, initialCapacity: 1),
              let directionalLights = PNIDynamicBuffer<DirectionalLight>(device: device, initialCapacity: 1),
              let spotLights = PNIDynamicBuffer<SpotLight>(device: device, initialCapacity: 1) else {
                  return nil
        }
        self.omniLights = PNAnyDynamicBuffer(omniLights)
        self.ambientLights = PNAnyDynamicBuffer(ambientLights)
        self.cameras = PNAnyDynamicBuffer(cameras)
        self.modelCoordinateSystems = PNAnyDynamicBuffer(modelCoordinateSystems)
        self.matrixPalettes = PNAnyDynamicBuffer(matrixPalettes)
        self.directionalLights = PNAnyDynamicBuffer(directionalLights)
        self.spotLights = PNAnyDynamicBuffer(spotLights)
    }
    mutating func upload(camera: inout PNCamera, index: Int) {
        var uniforms = [CameraUniforms(projectionMatrix: camera.projectionMatrix, index: Int32(index))]
        cameras.upload(data: &uniforms)
    }

}
