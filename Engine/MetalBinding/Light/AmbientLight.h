//
//  Copyright © 2021 Mateusz Stompór. All rights reserved.
//

#ifndef AMBIENT_LIGHT_H
#define AMBIENT_LIGHT_H

struct AmbientLight {
    float diameter;
    simd_float3 color;
    float intensity;
    int idx;
};

#endif /* AMBIENT_LIGHT_H */
