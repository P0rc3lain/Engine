//
//  Copyright © 2021 Mateusz Stompór. All rights reserved.
//

#include "Transformation.h"

using namespace metal;

float3x3 extractRotation(float4x4 transformation) {
    return float3x3(transformation.columns[0].xyz,
                    transformation.columns[1].xyz,
                    transformation.columns[2].xyz);
}

float4 extractPosition(float4x4 transformation) {
    return transformation * float4(0, 0, 0, 1);
}
