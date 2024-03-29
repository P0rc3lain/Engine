//
//  Copyright © 2021 Mateusz Stompór. All rights reserved.
//

import PNShared

/// Contains data of uniforms required for scene rendering.
public protocol PNBufferStore {
    var omniLights: PNAnyDynamicBuffer<OmniLight> { get }
    var ambientLights: PNAnyDynamicBuffer<AmbientLight> { get }
    var directionalLights: PNAnyDynamicBuffer<DirectionalLight> { get }
    var spotLights: PNAnyDynamicBuffer<SpotLight> { get }
    var cameras: PNAnyDynamicBuffer<CameraUniforms> { get }
    var modelCoordinateSystems: PNAnyDynamicBuffer<ModelUniforms> { get }
    var matrixPalettes: PNAnyDynamicBuffer<PNBLTransform> { get }
}
