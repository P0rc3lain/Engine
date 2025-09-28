//
//  Copyright © 2025 Mateusz Stompór. All rights reserved.
//

#pragma once

#include <metal_stdlib>

struct Material {
    metal::texture2d<half> albedo [[id(0)]];
    metal::texture2d<half> roughness [[id(1)]];
    metal::texture2d<float> normals [[id(2)]];
    metal::texture2d<half> metallic [[id(3)]];
};
