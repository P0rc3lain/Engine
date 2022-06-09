//
//  Copyright © 2021 Mateusz Stompór. All rights reserved.
//

#include <metal_stdlib>

#include "Shaders/Common/Animation.h"

#include "MetalBinding/Model.h"
#include "MetalBinding/Vertex.h"
#include "MetalBinding/Constant.h"
#include "MetalBinding/Attribute/Bridge.h"
#include "MetalBinding/Light/DirectionalLight.h"

using namespace metal;

struct RasterizerData {
    float4 clipSpacePosition [[position]];
    uint layer [[render_target_array_index]];
};

constant bool hasSkeleton [[function_constant(kFunctionConstantDirectionalShadowHasSkeleton)]];

vertex RasterizerData vertexDirectionalLightShadow(Vertex in [[stage_in]],
                                                   constant uint & instanceId [[buffer(kAttributeDirectionalShadowVertexShaderBufferInstanceId)]],
                                                   constant DirectionalLight * directionalLights [[buffer(kAttributeDirectionalShadowVertexShaderBufferDirectionalLights)]],
                                                   constant ModelUniforms * modelUniforms [[buffer(kAttributeDirectionalShadowVertexShaderBufferModelUniforms)]],
                                                   constant simd_float4x4 * matrixPalettes [[buffer(kAttributeDirectionalShadowVertexShaderBufferMatrixPalettes)]],
                                                   constant int & index [[buffer(kAttributeSpotShadowVertexShaderBufferObjectIndex)]]) {
    float4 totalPosition = hasSkeleton ? calculatePosition(in, matrixPalettes) : float4(in.position, 1);
    float4 worldPosition = modelUniforms[index].modelMatrix * totalPosition;
    DirectionalLight light = directionalLights[instanceId];
    return RasterizerData {
        light.projectionMatrix * light.rotationMatrixInverse * worldPosition,
        instanceId
    };
}
