//
//  Copyright © 2021 Mateusz Stompór. All rights reserved.
//

#include "Animation.h"
#include "../../MetalBinding/Vertex.h"
#include "../../MetalBinding/Constant.h"

using namespace metal;

float4 calculatePosition(Vertex in, constant float4x4 * matrixPalettes) {
    float4 totalPosition = float4(0);
    for(auto i{0}; i < MAX_JOINT_NUMBER; ++i) {
        float4x4 transformMatrix = matrixPalettes[in.jointIndices[i]];
        float4 weight = in.jointWeights[i];
        float4 localPosition = transformMatrix * float4(in.position, 1);
        totalPosition += weight * localPosition;
    }
    return totalPosition;
}

Pose calculatePose(Vertex in, constant metal::float4x4 * matrixPalettes) {
    float4 totalPosition{0};
    float4 totalNormal{0};
    float4 totalTangent{0};
    for(auto i{0}; i < MAX_JOINT_NUMBER; ++i) {
        auto transform = matrixPalettes[in.jointIndices[i]];
        float4 weight = in.jointWeights[i];

        float4 localPosition = transform * float4(in.position, 1);
        totalPosition += weight * localPosition;

        float4 localNormal = transform * float4(in.normal, 0);
        totalNormal += weight * localNormal;

        float4 localTangent = transform * float4(in.tangent, 0);
        totalTangent += weight * localTangent;
    }
    return Pose {
        totalPosition,
        totalNormal.xyz,
        totalTangent.xyz
    };
}
