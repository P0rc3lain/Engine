//
//  Camera.h
//  Engine
//
//  Created by Mateusz Stompór on 15/10/2021.
//

#ifndef CAMERA_H
#define CAMERA_H

struct CameraUniforms {
    simd_float4x4 projectionMatrix;
    simd_float4x4 viewMatrix;
    simd_float4x4 viewMatrixInverse;
};

#endif /* CAMERA_H */
