//
//  Copyright © 2021 Mateusz Stompór. All rights reserved.
//

#ifndef PBR_H
#define PBR_H

#include <simd/simd.h>

float normalDistributionGGX(float3 n, float3 h, float roughness);
float geometricAttenuationSmith(float3 n, float3 v, float k);
float schlick(float3  n, float3 v, float3 l, float roughness);
float3 fresnel(float3 h, float3 v, float3 f0);
float3 cookTorrance(float3 n, float3 v, float3 h, float3 l, float roughness, float3 f0);

#endif /* PBR_H */
