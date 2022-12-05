//
//  Copyright © 2022 Mateusz Stompór. All rights reserved.
//

#pragma once

#include <simd/simd.h>

#include "MetalBinding/PNAttribute/Bridge.h"

struct FrozenParticle {
    simd_float3 position metal_only([[attribute(kFrozenParticleAttributePosition)]]);
    float life metal_only([[attribute(kFrozenParticleAttributeLife)]]);
    float lifespan metal_only([[attribute(kFrozenParticleAttributeLifespan)]]);
    float scale metal_only([[attribute(kFrozenParticleAttributeScale)]]);
};
