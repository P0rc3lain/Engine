//
//  Copyright © 2025 Mateusz Stompór. All rights reserved.
//

#pragma once

#include <metal_stdlib>

struct Material {
    metal::texture2d<float> albedo [[id(0)]];
    metal::texture2d<float> roughness [[id(1)]];
    metal::texture2d<float> normals [[id(2)]];
    metal::texture2d<float> metallic [[id(3)]];
};
