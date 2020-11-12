//
//  PBR.h
//  Porcelain
//
//  Created by Mateusz Stompór on 11/11/2020.
//

#ifndef PBR_H
#define PBR_H

#include <simd/simd.h>

using namespace metal;

float nd(float3 normal, float3 halfway, float roughness) {
    float alpha = roughness * roughness;
    float alphaSquared = alpha * alpha;
    float numerator = alphaSquared;
    float ndh = dot(normal, halfway);
    float influence = ndh * ndh * (alphaSquared - 1) + 1;
    float denominator = M_PI_F * influence * influence;
    return numerator / denominator;
}

float schlick_f(float3 normal, float3 v, float k) {
    float ndv = dot(normal, v);
    float numerator = max(ndv, 0.0f);
    float denominator = max(ndv * (1 - k) + k, 0.001f);
    return numerator / denominator;
}

float schlick(float3  normal, float3 view, float3 light, float roughness) {
    float k = pow((roughness + 1), 2)/8;
    return schlick_f(normal, light, k) * schlick_f(normal, light, k);
}

float fresnel(float3 halfway, float3 view, float metallic) {
    float vdh = dot(view, halfway);
    float power = (-5.55473 * vdh - 6.98316) * vdh;
    return metallic + (1 - metallic) * pow(2, power);
}

float brdf(float3 normal, float3 view, float3 halfway, float3 light, float roughness, float metallic) {
    float numerator = schlick(normal, view, light, roughness) * fresnel(halfway, view, metallic) * nd(normal, halfway, roughness);
    float ndl = max(dot(normal, light), 0.0f);
    float ndh = max(dot(normal, halfway), 0.0f);
    float denominator = 4 * ndl * ndh;
    return numerator / max(denominator, 0.001f);
}

#endif /* PBR_H */
