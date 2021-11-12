//
//  Copyright © 2021 Mateusz Stompór. All rights reserved.
//

#include <metal_stdlib>

#define RED_VALUE_WEIGHT 0.2126f
#define GREEN_VALUE_WEIGHT 0.7152f
#define BLUE_VALUE_WEIGHT 0.0722f

using namespace metal;

float luminance(float3 color) {
    return dot(color, float3(RED_VALUE_WEIGHT, GREEN_VALUE_WEIGHT, BLUE_VALUE_WEIGHT));
}
