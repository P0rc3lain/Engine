//
//  Copyright © 2021 Mateusz Stompór. All rights reserved.
//

#pragma once

#include <simd/simd.h>

#include "Compatibility.h"
#include "Attribute/Bridge.h"

struct Vertex {
    simd_float3 position metal_only([[attribute(kVertexAttributePositionIndex)]]);
    simd_float3 normal metal_only([[attribute(kVertexAttributeNormalIndex)]]);
    simd_float3 tangent metal_only([[attribute(kVertexAttributeTangentIndex)]]);
    simd_float2 textureUV metal_only([[attribute(kVertexAttributeTextureUV)]]);
    simd_ushort4 jointIndices metal_only([[attribute(kVertexAttributeJointIndices)]]);
    simd_float4 jointWeights metal_only([[attribute(kVertexAttributeJointWeights)]]);
};

struct VertexP {
    simd_float3 position metal_only([[attribute(kVertexPAttributePositionIndex)]]);
};
