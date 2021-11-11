//
//  Copyright © 2021 Mateusz Stompór. All rights reserved.
//

#include "Animation.h"
#include "../../MetalBinding/Vertex.h"
#include "../../MetalBinding/Constant.h"

using namespace metal;

float4 calculatePose(Vertex in, constant float4x4 * matrixPalettes) {
    float4 totalPosition = float4(0);
    for(auto i{0}; i < MAX_JOINT_NUMBER; ++i) {
        float4x4 transformMatrix = matrixPalettes[in.jointIndices[i]];
        float4 weight = in.jointWeights[i];
        float4 localPosition = transformMatrix * float4(in.position, 1);
        totalPosition += weight * localPosition;
    }
    return totalPosition;
}
