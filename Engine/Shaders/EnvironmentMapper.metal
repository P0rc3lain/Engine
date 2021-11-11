//
//  Copyright © 2021 Mateusz Stompór. All rights reserved.
//

#include <simd/simd.h>
#include <metal_stdlib>

#include "Common/Transformation.h"
#include "../MetalBinding/Model.h"
#include "../MetalBinding/Camera.h"
#include "../MetalBinding/Attribute.h"

using namespace metal;

struct RasterizedData {
    float4 ndcPosition [[position]];
    float3 viewPosition;
};

vertex RasterizedData environmentVertexShader(float3 in [[stage_in attribute(kAttributeEnvironmentVertexShaderBufferStageIn)]],
                                              constant CameraUniforms & camera [[buffer(kAttributeEnvironmentVertexShaderBufferCamera)]],
                                              constant ModelUniforms * modelUniforms [[buffer(kAttributeEnvironmentVertexShaderBufferModelUniforms)]]) {
    float3x3 extractedRotation = extract_rotation(modelUniforms[camera.index].modelMatrix);
    return RasterizedData {
        camera.projectionMatrix * float4(extractedRotation * in, 1),
        in
    };
}

fragment half4 environmentFragmentShader(RasterizedData in [[stage_in]],
                                         texturecube<half> cubeTexture [[texture(kAttributeEnvironmentFragmentShaderTextureCubeMap)]]) {
    constexpr sampler cubeSampler(mag_filter::linear, min_filter::nearest);
    float3 coordinates = float3(in.viewPosition.xy, -in.viewPosition.z);
    return cubeTexture.sample(cubeSampler, coordinates);
}
