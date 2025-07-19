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
        
    projected.z = length(lightSpacePosition.xyz) / light.farPlane;
    projected.z *= projected.w;
    
    return RasterizerData {
        projected,
        lightIndex * 6 + face
    };
}
