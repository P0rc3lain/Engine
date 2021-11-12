//
//  Copyright © 2021 Mateusz Stompór. All rights reserved.
//

#ifndef PBR_H
#define PBR_H

#include <simd/simd.h>

#include "LightingInput.h"

float3 lighting(float3 l, float3 eye, LightingInput input, float3 lightColor, float lightIntensity);

#endif /* PBR_H */
