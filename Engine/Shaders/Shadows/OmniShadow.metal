//
//  Copyright © 2021 Mateusz Stompór. All rights reserved.
//

#include <metal_stdlib>

#include "Shaders/Common/Animation.h"

#include "MetalBinding/PNShared/Model.h"
#include "MetalBinding/PNShared/Vertex.h"
#include "MetalBinding/PNShared/Light/OmniLight.h"

#include "MetalBinding/PNAttribute/Bridge.h"

using namespace metal;

struct RasterizerData {
    float4 clipSpacePosition [[position]];
    float distanceToLight;
    uint layer [[render_target_array_index]];
};

constant bool hasSkeleton [[function_constant(kFunctionConstantOmniShadowHasSkeleton)]];

vertex RasterizerData vertexOmniLightShadow(Vertex in [[stage_in]],
                                            constant uint & lightIndex [[buffer(kAttributeOmniShadowVertexShaderBufferLightIndex)]],
                                            constant OmniLight * omniLights [[buffer(kAttributeOmniShadowVertexShaderBufferOmniLights)]],
                                            constant ModelUniforms * modelUniforms [[buffer(kAttributeOmniShadowVertexShaderBufferModelUniforms)]],
                                            constant simd_float4x4 * matrixPalettes [[buffer(kAttributeOmniShadowVertexShaderBufferMatrixPalettes)]],
                                            constant int & index [[buffer(kAttributeOmniShadowVertexShaderBufferObjectIndex)]],
                                            constant simd_float4x4 * rotations [[buffer(kAttributeOmniShadowVertexShaderBufferRotations)]],
                                            unsigned int face [[instance_id]]) {
    float4 totalPosition = hasSkeleton ? totalPosition = calculatePosition(in, matrixPalettes) : float4(in.position, 1);
    float4 worldPosition = modelUniforms[index].modelMatrix * totalPosition;
    OmniLight light = omniLights[lightIndex];
    float4 lightSpacePosition = modelUniforms[light.idx].modelMatrixInverse * worldPosition;
    float4 orientedPosition = rotations[face] * lightSpacePosition;
    float4 projected = light.projectionMatrix * orientedPosition;
    
    float4 edgePosition = light.projectionMatrixInverse * float4(0, 0, 1, 1);
    edgePosition /= edgePosition.w;
    
    float maxDepth = -edgePosition.z;
    
    return RasterizerData {
        projected,
        length(lightSpacePosition.xyz) / maxDepth,
        lightIndex * 6 + face
    };
}

struct Output {
    float depth [[depth(any)]];
};

fragment Output fragmentOmniLightShadow(RasterizerData in [[stage_in]]) {
    return Output{in.distanceToLight};
}
