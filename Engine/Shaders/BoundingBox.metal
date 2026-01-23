//
//  Copyright © 2025 Mateusz Stompór. All rights reserved.
//

#include <metal_stdlib>

#include "MetalBinding/PNShared/Model.h"
#include "MetalBinding/PNShared/Vertex.h"
#include "MetalBinding/PNShared/Camera.h"

using namespace metal;

struct RasterizerData {
    float4 clipSpacePosition [[position]];
};

vertex RasterizerData vertexBoundingBox(VertexP in [[stage_in]],
                                        constant CameraUniforms & cameraUniforms [[buffer(1)]],
                                        constant ModelUniforms * modelUniforms [[buffer(2)]]) {
    float4 worldPosition = float4(in.position, 1.0f);
    float4 cameraSpacePosition = modelUniforms[cameraUniforms.index].modelMatrixInverse * worldPosition;
    return RasterizerData {
        cameraUniforms.projectionMatrix * cameraSpacePosition,
    };
}

fragment float4 fragmentBoundingBox(RasterizerData in [[stage_in]]) {
    return float4(1, 0, 0, 1);
}
