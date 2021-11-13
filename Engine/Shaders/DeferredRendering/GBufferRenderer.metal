//
//  Copyright © 2021 Mateusz Stompór. All rights reserved.
//

#include <metal_stdlib>

#include "../Common/PBR.h"
#include "../Common/Animation.h"
#include "../Common/Transformation.h"
#include "../../MetalBinding/Model.h"
#include "../../MetalBinding/Vertex.h"
#include "../../MetalBinding/Camera.h"

using namespace metal;

constant bool hasSkeleton [[function_constant(0)]];

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

vertex RasterizerData vertexGBuffer(Vertex in [[stage_in]],
                                    constant CameraUniforms & cameraUniforms [[buffer(kAttributeGBufferVertexShaderBufferCameraUniforms)]],
                                    constant ModelUniforms * modelUniforms [[buffer(kAttributeGBufferVertexShaderBufferModelUniforms)]],
                                    constant simd_float4x4 * matrixPalettes [[buffer(kAttributeGBufferVertexShaderBufferMatrixPalettes)]],
                                    constant int & index [[ buffer(kAttributeGBufferVertexShaderBufferObjectIndex) ]]) {
    Pose pose = hasSkeleton ? calculatePose(in, matrixPalettes) : Pose{float4(in.position, 1), in.normal, in.tangent};
    matrix_float3x3 rotation = extract_rotation(modelUniforms[index].modelMatrix);
    float3 rotatedNormal = rotation * pose.normal;
    float3 rotatedTangent = rotation * pose.tangent;
    float4 worldPosition = modelUniforms[index].modelMatrix * pose.position;
    float4 cameraSpacePosition = modelUniforms[cameraUniforms.index].modelMatrix * worldPosition;
    float3x3 cameraRotation = float3x3(modelUniforms[cameraUniforms.index].modelMatrix.columns[0].xyz,
                                       modelUniforms[cameraUniforms.index].modelMatrix.columns[1].xyz,
                                       modelUniforms[cameraUniforms.index].modelMatrix.columns[2].xyz);
    float3x3 TBN = float3x3(normalize(rotatedTangent),
                            normalize(cross(rotatedTangent, rotatedNormal)),
                            normalize(rotatedNormal));
    float3x3 cameraTBN = cameraRotation * TBN;
    return RasterizerData {
        cameraUniforms.projectionMatrix * cameraSpacePosition,
        cameraSpacePosition.xyz,
        cameraTBN.columns[0],
        cameraTBN.columns[1],
        cameraTBN.columns[2],
        in.textureUV
    };
}

fragment GBufferData fragmentGBuffer(RasterizerData in [[stage_in]],
                                     texture2d<float> albedo [[texture(kAttributeGBufferFragmentShaderTextureAlbedo)]],
                                     texture2d<float> roughness [[texture(kAttributeGBufferFragmentShaderTextureRoughness)]],
                                     texture2d<float> normals [[texture(kAttributeGBufferFragmentShaderTextureNormals)]],
                                     texture2d<float> metallic [[texture(kAttributeGBufferFragmentShaderTextureMetallic)]],
                                     constant CameraUniforms & cameraUniforms [[buffer(kAttributeGBufferVertexShaderBufferCameraUniforms)]]) {
    constexpr sampler textureSampler(mag_filter::linear, min_filter::linear, mip_filter::linear, address::mirrored_repeat);
    simd_float3x3 TBN(in.t, in.b, in.n);
    // 0.04 is reflactance for common materials
    // should be possible to configure it
    float3 normalEncoded = normals.sample(textureSampler, in.uv).xyz;
    float3 normalDecoded = (normalEncoded * 2) - 1;
    float3 normalWorldSpace = TBN * normalDecoded;
    return GBufferData {
        float4(albedo.sample(textureSampler, in.uv).xyz, roughness.sample(textureSampler, in.uv).x),
        float4(normalWorldSpace, metallic.sample(textureSampler, in.uv).x),
        float4(in.cameraSpacePosition, 0.04)
    };
}
