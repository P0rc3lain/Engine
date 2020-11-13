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

float normalDistributionGGX(float3 normal, float3 halfway, float roughness) {
    float alpha = roughness * roughness;
    float alphaSquared = alpha * alpha;
    float numerator = alphaSquared;
    float ndh = dot(normal, halfway);
    float influence = ndh * ndh * (alphaSquared - 1) + 1;
    float denominator = M_PI_F * influence * influence;
    return numerator / denominator;
}

float schlick_f(float3 n, float3 v, float k) {
    float ndv = saturate(dot(n, v));
    float denominator = max(ndv * (1 - k) + k, 0.001f);
    return ndv / denominator;
}

float schlick(float3  normal, float3 view, float3 light, float roughness) {
    float k = pow((roughness + 1), 2)/8;
    return schlick_f(normal, light, k) * schlick_f(normal, light, k);
}

float3 fresnel(float3 h, float3 v, float3 f0) {
    float vdh = dot(v, h);
    float power = (-5.55473 * vdh - 6.98316) * vdh;
    return f0 + (1 - f0) * pow(2, power);
}

float3 cookTorrance(float3 n, float3 v, float3 h, float3 l, float roughness, float3 f0) {
    float3 numerator = schlick(n, v, l, roughness) * fresnel(h, v, f0) * normalDistributionGGX(n, h, roughness);
    float ndl = saturate(dot(n, l));
    float ndh = saturate(dot(n, h));
    float denominator = 4 * ndl * ndh;
    return numerator / max(denominator, 0.001f);
}



#endif /* PBR_H */
