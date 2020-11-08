//
//  EnvironmentMapper.metal
//  Porcelain
//
//  Created by Mateusz Stompór on 07/11/2020.
//

#include <simd/simd.h>
#include <metal_stdlib>

using namespace metal;

struct CubeVertex {
    simd_float4 position [[attribute(0)]];
    simd_float4 normal [[attribute(1)]];
};

struct RasterizerCubeData {
    float4 ndcPosition [[position]];
    float4 viewPosition;
};

struct Uniforms {
    matrix_float4x4 projection_matrix;
    matrix_float4x4 rotation;
    simd_float3 translation;
    simd_float3 scale;
};

matrix_float4x4 translationn(metal::float3 translation) {
    return matrix_float4x4(1,                       0,                      0,                  0,
                           0,                       1,                      0,                  0,
                           0,                       0,                      1,                  0,
                           translation.x,           translation.y,          translation.z,      1);
}

vertex RasterizerCubeData environmentVertexShader(CubeVertex in [[stage_in]],
                                                  constant Uniforms * uniforms [[buffer(1)]]) {
    RasterizerCubeData out;
    float4 clipSpacePosition = uniforms->rotation * in.position;
    out.ndcPosition = uniforms->projection_matrix * clipSpacePosition;
    out.viewPosition = in.position;
    return out;
}

fragment half4 environmentFragmentShader(RasterizerCubeData in [[stage_in]],
                                          texturecube<half> cubeTexture [[texture(0)]]) {
    sampler sam;
    float3 texCoords = float3(in.viewPosition.x, in.viewPosition.y, -in.viewPosition.z);
    return cubeTexture.sample(sam, texCoords);
}
