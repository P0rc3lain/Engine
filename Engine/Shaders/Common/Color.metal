//
//  Copyright © 2021 Mateusz Stompór. All rights reserved.
//

#include <metal_stdlib>

using namespace metal;

float luminance(float3 color) {
    return dot(color, float3(0.2126f, 0.7152f, 0.0722f));
}

half luminance(half3 color) {
    return dot(color, half3(0.2126h, 0.7152h, 0.0722h));
}
