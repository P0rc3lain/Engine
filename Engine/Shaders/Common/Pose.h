//
//  Copyright © 2021 Mateusz Stompór. All rights reserved.
//

#pragma once

#include <metal_stdlib>

struct Pose {
    metal::float4 position;
    metal::float3 normal;
    metal::float3 tangent;
};
