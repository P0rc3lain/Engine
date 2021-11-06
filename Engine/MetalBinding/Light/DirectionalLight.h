//
//  Copyright © 2021 Mateusz Stompór. All rights reserved.
//

#ifndef DIRECTIONAL_LIGHT_H
#define DIRECTIONAL_LIGHT_H

struct DirectionalLight {
    simd_float3 color;
    float intensity;
    simd_float3 direction;
};

#endif /* DIRECTIONAL_LIGHT_H */
