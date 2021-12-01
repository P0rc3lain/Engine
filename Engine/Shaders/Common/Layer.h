//
//  Copyright © 2021 Mateusz Stompór. All rights reserved.
//

#ifndef LAYER_H
#define LAYER_H

#include <simd/simd.h>
#include <metal_stdlib>

float3 add(float3 a, float3 b, float w);
float3 screen(float3 a, float3 b, float w);
float3 overlay(float3 a, float3 b, float w);
float3 softLight(float3 a, float3 b, float w);

#endif /* LAYER_H */
