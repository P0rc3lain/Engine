//
//  Copyright © 2021 Mateusz Stompór. All rights reserved.
//

#include <simd/simd.h>
#include <metal_stdlib>

#include "Shaders/Common/Transformation.h"

#include "MetalBinding/PNShared/Model.h"
#include "MetalBinding/PNShared/Vertex.h"
#include "MetalBinding/PNShared/Camera.h"

#include "MetalBinding/PNAttribute/Bridge.h"

using namespace metal;

struct RasterizedData {
    float4 ndcPosition [[position]];
    float3 viewPosition;
};

vertex RasterizedData environmentVertexShader(VertexP in [[stage_in]],
                                              constant CameraUniforms & camera [[buffer(kAttributeEnvironmentVertexShaderBufferCameraUniforms)]],
                                              constant ModelUniforms * modelUniforms [[buffer(kAttributeEnvironmentVertexShaderBufferModelUniforms)]]) {
    float4x4 projectionMatrix = perspectiveProjection(30.0f, 16.0f/9.0f, 0.01f, 100.0f);
    float3x3 extractedRotation = extractRotation(modelUniforms[camera.index].modelMatrixInverse);
    return RasterizedData {
        projectionMatrix * float4(extractedRotation * in.position, 1),
        in.position
    };
}

fragment half4 environmentFragmentShader(RasterizedData in [[stage_in]],
                                         texturecube<half> cubeTexture [[texture(kAttributeEnvironmentFragmentShaderTextureCubeMap)]]) {
    constexpr sampler cubeSampler(filter::linear);
    float3 coordinates = float3(in.viewPosition.xy, -in.viewPosition.z);
    return cubeTexture.sample(cubeSampler, coordinates);
}
