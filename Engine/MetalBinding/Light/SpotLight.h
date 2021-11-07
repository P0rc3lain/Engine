//
//  Copyright © 2021 Mateusz Stompór. All rights reserved.
//

#ifndef SPOT_LIGHT_H
#define SPOT_LIGHT_H

struct SpotLight {
    simd_float3 color;
    float intensity;
    simd_float3 direction;
    float coneAngle;
    int idx;
};

#endif /* SPOT_LIGHT_H */
