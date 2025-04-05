//
//  Copyright © 2021 Mateusz Stompór. All rights reserved.
//

#include <metal_stdlib>

#include "Shaders/Common/Animation.h"
#include "Shaders/Common/Transformation.h"

#include "MetalBinding/PNShared/Model.h"
#include "MetalBinding/PNShared/Vertex.h"
#include "MetalBinding/PNShared/Camera.h"

using namespace metal;

constant bool hasSkeleton [[function_constant(kFunctionConstantGBufferHasSkeleton)]];

struct RasterizerData {
    float4 clipSpacePosition [[position]];
    float3 cameraSpacePosition;
    float3 t;
    float3 b;
    float3 n;
    float2 uv;
};

struct GBufferData {
    float4 albedoRoughness [[color(0)]];
    float4 normalMetallic [[color(1)]];
    float4 positionReflectance [[color(2)]];
};

// Vertex function
#define bCameraUniformsVertex buffer(kAttributeGBufferVertexShaderBufferCameraUniforms)
#define bModelUniformsVertex buffer(kAttributeGBufferVertexShaderBufferModelUniforms)
#define bMatrixPalettesVertex buffer(kAttributeGBufferVertexShaderBufferMatrixPalettes)
#define bIndexVertex buffer(kAttributeGBufferVertexShaderBufferObjectIndex)

// Fragment function
#define tAlbedoFragment texture(kAttributeGBufferFragmentShaderTextureAlbedo)
#define tRoughnessFragment texture(kAttributeGBufferFragmentShaderTextureRoughness)
#define tNormalsFragment texture(kAttributeGBufferFragmentShaderTextureNormals)
#define tMetallicFragment texture(kAttributeGBufferFragmentShaderTextureMetallic)

vertex RasterizerData vertexGBuffer(Vertex in [[stage_in]],
                                    constant CameraUniforms & cameraUniforms [[bCameraUniformsVertex]],
                                    constant ModelUniforms * modelUniforms [[bModelUniformsVertex]],
                                    constant simd_float4x4 * matrixPalettes [[bMatrixPalettesVertex]],
                                    constant int & index [[bIndexVertex]]) {
    Pose pose = hasSkeleton ? calculatePose(in, matrixPalettes) : Pose{float4(in.position, 1), in.normal, in.tangent};
    matrix_float3x3 rotation = extractRotation(modelUniforms[index].modelMatrix);
    pose.tangent.x = pose.tangent.x < 0 ? -pose.tangent.x : pose.tangent.x;
    pose.tangent.y = pose.tangent.y < 0 ? -pose.tangent.y : pose.tangent.y;
    pose.tangent.z = pose.tangent.z < 0 ? -pose.tangent.z : pose.tangent.z;
    float3 rotatedNormal = rotation * pose.normal;
    float3 rotatedTangent = rotation * pose.tangent;
    float3 rotatedBitangent = cross(rotatedNormal, rotatedTangent);
    float4 worldPosition = modelUniforms[index].modelMatrix * pose.position;
    float4x4 cameraTransform = modelUniforms[cameraUniforms.index].modelMatrixInverse;
    float4 cameraSpacePosition = cameraTransform * worldPosition;
    float3x3 cameraRotation = extractRotation(cameraTransform);
    return {
        cameraUniforms.projectionMatrix * cameraSpacePosition,
        cameraSpacePosition.xyz,
        normalize(cameraRotation * rotatedTangent),
        normalize(cameraRotation * rotatedBitangent),
        normalize(cameraRotation * rotatedNormal),
        in.textureUV
    };
}

fragment GBufferData fragmentGBuffer(RasterizerData in [[stage_in]],
                                     texture2d<float> albedo [[tAlbedoFragment]],
                                     texture2d<float> roughness [[tRoughnessFragment]],
                                     texture2d<float> normals [[tNormalsFragment]],
                                     texture2d<float> metallic [[tMetallicFragment]]) {
    constexpr sampler textureSampler(mag_filter::linear,
                                     min_filter::linear,
                                     mip_filter::linear,
                                     address::mirrored_repeat);
    simd_float3x3 TBN(in.t, in.b, in.n);
    // 0.04 is reflactance for common materials
    // should be possible to configure it
    float3 normalEncoded = normals.sample(textureSampler, in.uv).xyz;
    float3 normalDecoded = normalEncoded * 2 - 1;
    float3 normalWorldSpace = TBN * normalDecoded;
    float4 color = albedo.sample(textureSampler, in.uv);
    if (!color.a)
        discard_fragment();
    return {
        float4(color.xyz, roughness.sample(textureSampler, in.uv).x),
        float4(normalWorldSpace, metallic.sample(textureSampler, in.uv).x),
        float4(in.cameraSpacePosition, 0.04)
    };
}
