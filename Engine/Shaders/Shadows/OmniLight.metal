//
//  Copyright © 2021 Mateusz Stompór. All rights reserved.
//

#include <metal_stdlib>

#include "../Common/Animation.h"
#include "../../MetalBinding/Model.h"
#include "../../MetalBinding/Vertex.h"
#include "../../MetalBinding/Attribute.h"
#include "../../MetalBinding/Light/OmniLight.h"

using namespace metal;

struct RasterizerData {
    float4 clipSpacePosition [[position]];
    float distanceToLight;
    uint layer [[render_target_array_index]];
};

constant bool hasSkeleton [[ function_constant(0) ]];

vertex RasterizerData vertexOmniLightShadow(Vertex in [[stage_in]],
                                            uint instanceId [[instance_id]],
                                            constant OmniLight * omniLights [[buffer(kAttributeSpotShadowVertexShaderBufferSpotLights)]],
                                            constant ModelUniforms * modelUniforms [[buffer(kAttributeSpotShadowVertexShaderBufferModelUniforms)]],
                                            constant simd_float4x4 * matrixPalettes [[buffer(kAttributeSpotShadowVertexShaderBufferMatrixPalettes)]],
                                            constant int & index [[buffer(kAttributeSpotShadowVertexShaderBufferObjectIndex)]],
                                            constant simd_float4x4 * rotations [[buffer(kAttributeOmniShadowVertexShaderBufferRotations)]]) {
    float4 totalPosition = hasSkeleton ? totalPosition = calculatePosition(in, matrixPalettes) : float4(in.position, 1);
    float4 worldPosition = modelUniforms[index].modelMatrix * totalPosition;
    OmniLight light = omniLights[instanceId / 6];
    uint face = instanceId % 6;
    float4 lightSpacePosition = modelUniforms[light.idx].modelMatrixInverse * worldPosition;
    float4 orientedPosition = rotations[face] * lightSpacePosition;
    float4 projected = light.projectionMatrix * orientedPosition;
    return RasterizerData {
        projected,
        length(lightSpacePosition.xyz),
        instanceId
    };
}

struct Output {
    float depth [[depth(any)]];
};

fragment Output fragmentOmniLightShadow(RasterizerData in [[stage_in]]) {
    return Output{in.distanceToLight/100};
}
