//
//  Copyright © 2021 Mateusz Stompór. All rights reserved.
//

#ifndef POSE_H
#define POSE_H

#include <simd/simd.h>

struct Pose {
    float4 position;
    float3 normal;
    float3 tangent;
};

#endif /* POSE_H */
