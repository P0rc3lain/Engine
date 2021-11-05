//
//  Copyright © 2021 Mateusz Stompór. All rights reserved.
//

#include <metal_stdlib>

#include "../Common/PBR.h"
#include "../Common/Transformation.h"
#include "../../MetalBinding/Model.h"
#include "../../MetalBinding/Vertex.h"
#include "../../MetalBinding/Camera.h"

using namespace metal;

struct RasterizerData {
    float4 clipSpacePosition [[position]];
    float3 cameraSpacePosition;
    float3 t;
    float3 b;
    float3 n;
    float2 uv;
};

struct GBufferData {
    float4 albedoRoughness      [[color(0)]];
    float4 normalMetallic       [[color(1)]];
    float4 positionReflectance  [[color(2)]];
};

vertex RasterizerData gBufferVertex(Vertex in [[stage_in]],
                                    constant CameraUniforms & cameraUniforms [[buffer(kAttributeGBufferVertexShaderBufferCameraUniforms)]],
                                    constant ModelUniforms * modelUniforms [[buffer(kAttributeGBufferVertexShaderBufferModelUniforms)]],
                                    constant int & index [[ buffer(kAttributeGBufferVertexShaderBufferObjectIndex) ]]) {
    
    
    matrix_float3x3 rotation = extract_rotation(modelUniforms[index].modelMatrix);
    float4 worldPosition = modelUniforms[index].modelMatrix * float4(in.position, 1);
    float3 rotatedNormal = rotation * in.normal;
    float3 rotatedTangent = rotation * in.tangent;
    float4 cameraSpacePosition = modelUniforms[cameraUniforms.index].modelMatrix * worldPosition;
    float3x3 cameraRotation = float3x3(modelUniforms[cameraUniforms.index].modelMatrix.columns[0].xyz,
                                       modelUniforms[cameraUniforms.index].modelMatrix.columns[1].xyz,
                                       modelUniforms[cameraUniforms.index].modelMatrix.columns[2].xyz);
    float3x3 TBN = float3x3(normalize(rotatedTangent),
                            normalize(cross(rotatedTangent, rotatedNormal)),
                            normalize(rotatedNormal));
    float3x3 cameraTBN = cameraRotation * TBN;
    RasterizerData out;
    out.t = cameraTBN.columns[0];
    out.b = cameraTBN.columns[1];
    out.n = cameraTBN.columns[2];
    out.clipSpacePosition = cameraUniforms.projectionMatrix * cameraSpacePosition;
    out.cameraSpacePosition = cameraSpacePosition.xyz;
    out.uv = in.textureUV;
    return out;
}

vertex RasterizerData gBufferAnimatedVertex(Vertex in [[stage_in]],
                                            constant CameraUniforms & cameraUniforms [[buffer(kAttributeGBufferVertexShaderBufferCameraUniforms)]],
                                            constant ModelUniforms * modelUniforms [[buffer(kAttributeGBufferVertexShaderBufferModelUniforms)]],
                                            constant simd_float4x4 * matrixPalettes [[buffer(kAttributeGBufferVertexShaderBufferMatrixPalettes)]],
                                            constant int & index [[ buffer(kAttributeGBufferVertexShaderBufferObjectIndex) ]]) {
    float4 totalPosition = float4(0);
    float4 totalNormal = float4(0);
    float4 totalTangent = float4(0);
    for(int i=0; i<4; ++i) {
        float4x4 transformMatrix = matrixPalettes[in.jointIndices[i]];
        float4 weight = in.jointWeights[i];

        float4 localPosition = transformMatrix * float4(in.position, 1);
        totalPosition += weight * localPosition;

        float4 localNormal = transformMatrix * float4(in.normal, 0);
        totalNormal += weight * localNormal;

        float4 localTangent = transformMatrix * float4(in.tangent, 0);
        totalTangent += weight * localTangent;
    }
    matrix_float3x3 rotation = extract_rotation(modelUniforms[index].modelMatrix);
    float3 rotatedNormal = rotation * totalNormal.xyz;
    float3 rotatedTangent = rotation * totalTangent.xyz;
    float4 worldPosition = modelUniforms[index].modelMatrix * totalPosition;
    float4 cameraSpacePosition = modelUniforms[cameraUniforms.index].modelMatrix * worldPosition;
    float3x3 cameraRotation = float3x3(modelUniforms[cameraUniforms.index].modelMatrix.columns[0].xyz,
                                       modelUniforms[cameraUniforms.index].modelMatrix.columns[1].xyz,
                                       modelUniforms[cameraUniforms.index].modelMatrix.columns[2].xyz);
    float3x3 TBN = float3x3(normalize(rotatedTangent),
                            normalize(cross(rotatedTangent, rotatedNormal)),
                            normalize(rotatedNormal));
    float3x3 cameraTBN = cameraRotation * TBN;
    RasterizerData out;
    out.t = cameraTBN.columns[0];
    out.b = cameraTBN.columns[1];
    out.n = cameraTBN.columns[2];
    out.clipSpacePosition = cameraUniforms.projectionMatrix * cameraSpacePosition;
    out.cameraSpacePosition = cameraSpacePosition.xyz;
    out.uv = in.textureUV;
    return out;
}

fragment GBufferData gBufferFragment(RasterizerData in [[stage_in]],
                                     texture2d<float> albedo [[texture(kAttributeGBufferFragmentShaderTextureAlbedo)]],
                                     texture2d<float> roughness [[texture(kAttributeGBufferFragmentShaderTextureRoughness)]],
                                     texture2d<float> normals [[texture(kAttributeGBufferFragmentShaderTextureNormals)]],
                                     texture2d<float> metallic [[texture(kAttributeGBufferFragmentShaderTextureMetallic)]]) {
    constexpr sampler textureSampler(mag_filter::linear, min_filter::nearest, address::mirrored_repeat);
    simd_float3x3 TBN(in.t, in.b, in.n);
    GBufferData out;
    // 0.04 is reflactance for common materials
    // should be possible to configure it
    float3 normalEncoded = normals.sample(textureSampler, in.uv).xyz;
    float3 normalDecoded = (normalEncoded * 2) - 1;
    float3 normalWorldSpace = TBN * normalDecoded;
    out.positionReflectance = float4(in.cameraSpacePosition, 0.04);
    out.albedoRoughness = float4(albedo.sample(textureSampler, in.uv).xyz, roughness.sample(textureSampler, in.uv).x);
    out.normalMetallic = float4(normalWorldSpace, metallic.sample(textureSampler, in.uv).x);
    return out;
}
