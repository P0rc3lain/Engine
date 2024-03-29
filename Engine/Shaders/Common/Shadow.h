//
//  Copyright © 2021 Mateusz Stompór. All rights reserved.
//

#pragma once

#include <simd/simd.h>
#include <metal_stdlib>

float pcfDepth(metal::depth2d_array<float> shadowMaps,
               uint layer,
               float2 sampleCoordinate,
               int2 samples,
               float countedDepth,
               float bias);

float pcfDepth(metal::depthcube_array<float> shadowMaps,
               uint layer,
               float3 sampleCoordinate,
               int3 samples,
               float countedDepth,
               float bias,
               float offset);
