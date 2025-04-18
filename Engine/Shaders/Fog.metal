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

#define DENSITY 0.01f
#define GRADIENT 5.0f

using namespace metal;

struct RasterizedData {
    float4 ndcPosition [[position]];
    float3 viewPosition;
};

vertex RasterizedData fogVertexShader(VertexP in [[stage_in]],
                                      constant CameraUniforms & camera [[buffer(kAttributeFogVertexShaderBufferCameraUniforms)]],
                                      constant ModelUniforms * modelUniforms [[buffer(kAttributeFogVertexShaderBufferModelUniforms)]]) {
    float3x3 extractedRotation = extractRotation(modelUniforms[camera.index].modelMatrixInverse);
    return RasterizedData {
        camera.projectionMatrix * float4(extractedRotation * in.position, 1),
        in.position
    };
}

fragment float4 fogFragmentShader(RasterizedData in [[stage_in]],
                                 texture2d<float> pr [[texture(kAttributeFogFragmentShaderTexturePR)]],
                                 texturecube<float> cubeTexture [[texture(kAttributeFogFragmentShaderTextureCubeMap)]]) {
    constexpr sampler textureSampler(filter::linear);
    float3 coordinates = float3(in.viewPosition.xy, -in.viewPosition.z);
    float4 sample = cubeTexture.sample(textureSampler, coordinates);
    float2 uv = float2(in.ndcPosition.x / pr.get_width(), in.ndcPosition.y / pr.get_height());
    float fragmentDistance = length(pr.sample(textureSampler, uv).xyz);
    float fog = exp(-pow(fragmentDistance * DENSITY, GRADIENT));
    float visibility = max(float(0), min(float(1), fog));
    return float4(sample.xyz, visibility);
}
