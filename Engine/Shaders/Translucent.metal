//
//  Copyright © 2022 Mateusz Stompór. All rights reserved.
//

#include <metal_stdlib>

#include "Shaders/Common/Animation.h"

#include "MetalBinding/Model.h"
#include "MetalBinding/Vertex.h"
#include "MetalBinding/Camera.h"

using namespace metal;

constant bool hasSkeleton [[function_constant(kFunctionConstantTranslucentHasSkeleton)]];

struct RasterizerData {
    float4 clipSpacePosition [[position]];
    float2 uv;
};

vertex RasterizerData vertexTranslucent(Vertex in [[stage_in]],
                                       constant CameraUniforms & cameraUniforms [[buffer(kAttributeTranslucentVertexShaderBufferCameraUniforms)]],
                                       constant ModelUniforms * modelUniforms [[buffer(kAttributeTranslucentVertexShaderBufferModelUniforms)]],
                                       constant simd_float4x4 * matrixPalettes [[buffer(kAttributeTranslucentVertexShaderBufferMatrixPalettes)]],
                                       constant int & index [[buffer(kAttributeTranslucentVertexShaderBufferObjectIndex)]]) {
    Pose pose = hasSkeleton ? calculatePose(in, matrixPalettes) : Pose{float4(in.position, 1), in.normal, in.tangent};
    float4 worldPosition = modelUniforms[index].modelMatrix * pose.position;
    float4 cameraSpacePosition = modelUniforms[cameraUniforms.index].modelMatrixInverse * worldPosition;
    return RasterizerData {
        cameraUniforms.projectionMatrix * cameraSpacePosition,
        in.textureUV
    };
}

fragment float4 fragmentTranslucent(RasterizerData in [[stage_in]],
                                    texture2d<float> albedo [[texture(kAttributeTranslucentFragmentShaderTextureAlbedo)]]) {
    constexpr sampler textureSampler(mag_filter::linear,
                                     min_filter::linear,
                                     mip_filter::linear,
                                     address::mirrored_repeat);
    return albedo.sample(textureSampler, in.uv);
}
