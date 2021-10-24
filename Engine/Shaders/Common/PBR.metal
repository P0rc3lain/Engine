//
//  Copyright © 2021 Mateusz Stompór. All rights reserved.
//

#include "PBR.h"

#include <metal_stdlib>

using namespace metal;

float normalDistributionGGX(float3 n, float3 h, float roughness) {
    float alpha = roughness * roughness;
    float alphaSquared = alpha * alpha;
    float numerator = alphaSquared;
    float nh = dot(n, h);
    float influence = nh * nh * (alphaSquared - 1) + 1;
    float denominator = M_PI_F * influence * influence;
    return numerator / denominator;
}

float geometricAttenuationSmith(float3 n, float3 v, float k) {
    float nv = saturate(dot(n, v));
    float denominator = max(nv * (1 - k) + k, 0.001f); // 0.001f is bias
    return nv / denominator;
}

float schlick(float3  n, float3 v, float3 l, float roughness) {
    float k = (roughness + 1) * (roughness + 1) / 8;
    return geometricAttenuationSmith(n, v, k) * geometricAttenuationSmith(n, l, k);
}

float3 fresnel(float3 h, float3 v, float3 f0) {
    float vh = dot(v, h);
    float power = (-5.55473 * vh - 6.98316) * vh;
    return f0 + (1 - f0) * pow(2, power);
}

float3 cookTorrance(float3 n, float3 v, float3 h, float3 l, float roughness, float3 f0) {
    float3 numerator = schlick(n, v, l, roughness) * fresnel(h, v, f0) * normalDistributionGGX(n, h, roughness);
    float nl = saturate(dot(n, l));
    float nh = saturate(dot(n, h));
    float denominator = 4 * nl * nh;
    return numerator / max(denominator, 0.001f); // 0.001f is bias
}
