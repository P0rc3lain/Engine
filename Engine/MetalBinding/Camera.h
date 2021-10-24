//
//  Copyright © 2021 Mateusz Stompór. All rights reserved.
//

#ifndef CAMERA_H
#define CAMERA_H

struct CameraUniforms {
    simd_float4x4 projectionMatrix;
    simd_float4x4 viewMatrix;
    simd_float4x4 viewMatrixInverse;
};

#endif /* CAMERA_H */
