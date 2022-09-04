//
//  Copyright © 2022 Mateusz Stompór. All rights reserved.
//

#pragma once

#include <metal_stdlib>

inline float falloffAttenuation(float fragmentToLightDistanceSquared, float lightInfluenceRadius) {
    float dQuadrupled = fragmentToLightDistanceSquared;
    float a =  1 / metal::max(fragmentToLightDistanceSquared, 1e-4);
    float b = dQuadrupled / metal::pow(lightInfluenceRadius, 4);
    float c = metal::pow(1 - b, 2);
    return a * c;
}
