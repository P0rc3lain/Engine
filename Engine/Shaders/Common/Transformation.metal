//
//  Copyright © 2021 Mateusz Stompór. All rights reserved.
//

#include "Transformation.h"

using namespace metal;

float3x3 extractRotation(thread const float4x4 transformation) {
    return float3x3(transformation.columns[0].xyz,
                    transformation.columns[1].xyz,
                    transformation.columns[2].xyz);
}

float4 extractPosition(thread const float4x4 transformation) {
    return transformation.columns[3];
}
