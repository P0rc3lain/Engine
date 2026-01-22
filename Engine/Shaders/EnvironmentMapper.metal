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
    // Input cube covers range from -1 to 1 in each dimension.
    // Scale it up to ensure it covers whole visible area
    float3x3 scale = scaleMatrix3x3(100, 100, 100);
    float3x3 extractedRotation = extractRotation(modelUniforms[camera.index].modelMatrixInverse);
    return RasterizedData {
        camera.projectionMatrix * float4(normalizeEachColumn(extractedRotation) * scale * in.position, 1),
        in.position
    };
}

fragment half4 environmentFragmentShader(RasterizedData in [[stage_in]],
                                         texturecube<half> cubeTexture [[texture(kAttributeEnvironmentFragmentShaderTextureCubeMap)]]) {
    constexpr sampler cubeSampler(filter::linear);
    float3 coordinates = float3(in.viewPosition.xy, -in.viewPosition.z);
    return cubeTexture.sample(cubeSampler, coordinates);
}
