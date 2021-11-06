//
//  Copyright © 2021 Mateusz Stompór. All rights reserved.
//

#ifndef AMBIENT_LIGHT_H
#define AMBIENT_LIGHT_H

struct AmbientLight {
    float radius;
    simd_float3 color;
    float strength;
    int idx;
};

#endif /* AMBIENT_LIGHT_H */
