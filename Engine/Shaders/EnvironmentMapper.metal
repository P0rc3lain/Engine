//
//  Copyright © 2021 Mateusz Stompór. All rights reserved.
//

#include <simd/simd.h>
#include <metal_stdlib>

#include "../MetalBinding/Attribute.h"

using namespace metal;

struct Uniforms {
    matrix_float4x4 projection;
    matrix_float4x4 rotation;
};

struct RasterizedData {
    simd_float4 ndcPosition [[position]];
    simd_float4 viewPosition;
};

vertex RasterizedData environmentVertexShader(simd_float4 in [[stage_in attribute(kAttributeEnvironmentVertexShaderBufferStageIn)]],
                                              constant Uniforms & uniforms [[buffer(kAttributeEnvironmentVertexShaderBufferUniforms)]]) {
    RasterizedData out;
    out.ndcPosition = uniforms.projection * uniforms.rotation * in;;
    out.viewPosition = in;
    return out;
}

fragment half4 environmentFragmentShader(RasterizedData in [[stage_in]],
                                         texturecube<half> cubeTexture [[texture(kAttributeEnvironmentFragmentShaderTextureCubeMap)]]) {
    constexpr sampler cubeSampler(mag_filter::linear, min_filter::nearest);
    float3 coordinates = float3(in.viewPosition.xy, -in.viewPosition.z);
    return cubeTexture.sample(cubeSampler, coordinates);
}
