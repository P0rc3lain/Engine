//
//  Copyright © 2021 Mateusz Stompór. All rights reserved.
//

#include <metal_stdlib>
using namespace metal;

half3 channel_mix(half3 a, half3 b, half3 w) {
    return half3(mix(a.r, b.r, w.r),
                 mix(a.g, b.g, w.g),
                 mix(a.b, b.b, w.b));
}

half3 add(half3 a, half3 b, half w) {
    return a + a * b * w;
}

half3 screen(half3 a, half3 b, half w) {
    return mix(a, half3(1.0h) - (half3(1.0h) - a) * (half3(1.0h) - b), w);
}

half3 overlay(half3 a, half3 b, half w) {
    return mix(a,
               channel_mix(half3(2.0h) * a * b,
                           half3(1.0h) - half3(2.0h) * (half3(1.0h) - a) * (half3(1.0h) - b),
                           step(half3(0.5h), a)),
               w);
}

half3 softLight(half3 a, half3 b, half w) {
    return mix(a,
               pow(a, pow(half3(2.0h), half3(2.0h) * (half3(0.5h) - b))),
               w);
}
