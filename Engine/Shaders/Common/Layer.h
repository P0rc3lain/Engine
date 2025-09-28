//
//  Copyright © 2021 Mateusz Stompór. All rights reserved.
//

#pragma once

#include <simd/simd.h>
#include <metal_stdlib>

half3 add(half3 a, half3 b, half w);
half3 screen(half3 a, half3 b, half w);
half3 overlay(half3 a, half3 b, half w);
half3 softLight(half3 a, half3 b, half w);
