//
//  Copyright © 2021 Mateusz Stompór. All rights reserved.
//

#include <metal_stdlib>

#include "Shaders/Common/Animation.h"

#include "MetalBinding/Model.h"
#include "MetalBinding/Vertex.h"
#include "MetalBinding/Constant.h"
#include "MetalBinding/Light/SpotLight.h"
#include "MetalBinding/Attribute/Bridge.h"

using namespace metal;

struct RasterizerData {
    float4 clipSpacePosition [[position]];
    uint layer [[render_target_array_index]];
};

constant bool hasSkeleton [[function_constant(kFunctionConstantSpotShadowHasSkeleton)]];

vertex RasterizerData vertexSpotLightShadow(Vertex in [[stage_in]],
                                            constant uint & instanceId [[buffer(kAttributeSpotShadowVertexShaderBufferInstanceId)]],
                                            constant SpotLight * spotLights [[buffer(kAttributeSpotShadowVertexShaderBufferSpotLights)]],
                                            constant ModelUniforms * modelUniforms [[buffer(kAttributeSpotShadowVertexShaderBufferModelUniforms)]],
                                            constant simd_float4x4 * matrixPalettes [[buffer(kAttributeSpotShadowVertexShaderBufferMatrixPalettes)]],
                                            constant int & index [[buffer(kAttributeSpotShadowVertexShaderBufferObjectIndex)]]) {
    float4 totalPosition = hasSkeleton ? calculatePosition(in, matrixPalettes) : float4(in.position, 1);
    float4 worldPosition = modelUniforms[index].modelMatrix * totalPosition;
    SpotLight light = spotLights[instanceId];
    float4 lightSpacePosition = modelUniforms[light.idx].modelMatrixInverse * worldPosition;
    return RasterizerData {
        light.projectionMatrix * lightSpacePosition,
        instanceId
    };
}
