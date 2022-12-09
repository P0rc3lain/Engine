//
//  Copyright © 2021 Mateusz Stompór. All rights reserved.
//

import Metal
import PNShared
import simd

public final class PNIBufferStore: PNBufferStore {
    public var omniLights: PNAnyDynamicBuffer<OmniLight>
    public var ambientLights: PNAnyDynamicBuffer<AmbientLight>
    public var directionalLights: PNAnyDynamicBuffer<DirectionalLight>
    public var spotLights: PNAnyDynamicBuffer<SpotLight>
    public var cameras: PNAnyDynamicBuffer<CameraUniforms>
    public var modelCoordinateSystems: PNAnyDynamicBuffer<ModelUniforms>
    public var matrixPalettes: PNAnyDynamicBuffer<PNBLTransform>
    init?(device: MTLDevice) {
        guard let omniLights = PNIDynamicBuffer<OmniLight>(device: device),
              let cameras = PNIDynamicBuffer<CameraUniforms>(device: device),
              let modelCoordinateSystems = PNIDynamicBuffer<ModelUniforms>(device: device),
              let matrixPalettes = PNIDynamicBuffer<PNBLTransform>(device: device),
              let ambientLights = PNIDynamicBuffer<AmbientLight>(device: device),
              let directionalLights = PNIDynamicBuffer<DirectionalLight>(device: device),
              let spotLights = PNIDynamicBuffer<SpotLight>(device: device) else {
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
}
