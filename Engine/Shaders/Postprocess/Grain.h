//
//  Copyright © 2025 Mateusz Stompór. All rights reserved.
//

#pragma once

#include <simd/simd.h>

simd::half3 grain(float time,
                  simd::half2 texcoord,
                  simd::half3 inputColor);
