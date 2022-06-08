//
//  Copyright © 2022 Mateusz Stompór. All rights reserved.
//

#include <metal_stdlib>

#include "Shaders/Common/Animation.h"

#include "MetalBinding/Model.h"
#include "MetalBinding/Camera.h"
#include "MetalBinding/FrozenParticle.h"

using namespace metal;

struct RasterizerData {
    float4 clipSpacePosition [[position]];
    float pointSize [[point_size]];
    float life;
    float lifespan;
};

vertex RasterizerData vertexParticle(FrozenParticle in
                                     [[stage_in]],
                                     constant CameraUniforms & cameraUniforms
                                     [[buffer(kAttributeParticleVertexShaderBufferCameraUniforms)]],
                                     constant int & index
                                     [[buffer(kAttributeParticleVertexShaderBufferSystemIndex)]],
                                     constant ModelUniforms * modelUniforms
                                     [[buffer(kAttributeParticleVertexShaderBufferModelUniforms)]]) {
    float4 worldSpacePosition = modelUniforms[index].modelMatrix * float4(in.position, 1);
    float4 cameraSpacePosition = modelUniforms[cameraUniforms.index].modelMatrix * worldSpacePosition;
    float4 clipSpacePosition = cameraUniforms.projectionMatrix * cameraSpacePosition;
    return RasterizerData{clipSpacePosition, in.scale, in.life, in.lifespan};
}

fragment float4 fragmentParticle(RasterizerData in [[stage_in]],
                                 float2 coordinate [[point_coord]],
                                 constant uint2 & grid [[buffer(kAttributeParticleFragmentShaderBufferGrid)]],
                                 constant uint & useableTiles [[buffer(kAttributeParticleFragmentShaderBufferUseableTiles)]],
                                 texture2d<float> atlas [[texture(kAttributeParticleFragmentShaderAtlas)]]) {
    constexpr sampler textureSampler(mag_filter::linear,
                                     min_filter::linear,
                                     mip_filter::linear,
                                     address::clamp_to_edge);
    float ratio = clamp(in.life / in.lifespan, 0.0f, 1.0f);
    float preciseTile = useableTiles * ratio;
    float mixRatio = preciseTile - floor(preciseTile);
    uint tileNumber = ceil(useableTiles * ratio) - 1;
    uint previousTile = max(tileNumber - 1, uint(0));
    uint2 tilePosition{ tileNumber / grid.x, tileNumber % grid.x };
    uint2 previousTilePosition{ previousTile / grid.x, previousTile % grid.x };
    
    float2 normalizedPosition{
        (1.0f / grid.x) * tilePosition.y + coordinate.x / grid.x,
        (1.0f / grid.y) * tilePosition.x + coordinate.y / grid.y
    };
    float2 prevNormalizedPosition{
        (1.0f / grid.x) * previousTilePosition.y + coordinate.x / grid.x,
        (1.0f / grid.y) * previousTilePosition.x + coordinate.y / grid.y
    };
    float4 color = atlas.sample(textureSampler, normalizedPosition);
    float4 previousColor = atlas.sample(textureSampler, prevNormalizedPosition);
    
    float4 mixed = mix(previousColor, color, mixRatio);
    if (mixed.w < 0.1f)
        discard_fragment();
    return mixed;
}
