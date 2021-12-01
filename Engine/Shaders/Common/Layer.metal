//
//  Copyright © 2021 Mateusz Stompór. All rights reserved.
//

#include <metal_stdlib>

using namespace metal;

float3 channel_mix(float3 a, float3 b, float3 w) {
    return float3(mix(a.r, b.r, w.r), mix(a.g, b.g, w.g), mix(a.b, b.b, w.b));
}

float3 add(float3 a, float3 b, float w) {
    return a + a * b * w;
}

float3 screen(float3 a, float3 b, float w) {
    return mix(a, float3(1.0) - (float3(1.0) - a) * (float3(1.0) - b), w);
}

float3 overlay(float3 a, float3 b, float w) {
    return mix(a, channel_mix(2.0 * a * b, float3(1.0) - 2.0 * (float3(1.0) - a) * (float3(1.0) - b), step(float3(0.5), a)), w);
}

float3 softLight(float3 a, float3 b, float w) {
    return mix(a, pow(a, pow(float3(2.0), 2.0 * (float3(0.5) - b))), w);
}
