//
//  Copyright © 2021 Mateusz Stompór. All rights reserved.
//

#pragma once

#include <simd/simd.h>
#include <metal_stdlib>

float3 add(float3 a, float3 b, float w);
float3 screen(float3 a, float3 b, float w);
float3 overlay(float3 a, float3 b, float w);
float3 softLight(float3 a, float3 b, float w);
