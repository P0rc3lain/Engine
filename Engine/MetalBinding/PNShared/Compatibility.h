//
//  Copyright © 2021 Mateusz Stompór. All rights reserved.
//

#pragma once

#ifdef __METAL__
#include <metal_stdlib>
#define metal_only(expression) expression
#else
#define metal_only(expression)
#endif
