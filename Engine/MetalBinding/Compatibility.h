//
//  Copyright © 2021 Mateusz Stompór. All rights reserved.
//

#ifndef COMPATIBILITY_H
#define COMPATIBILITY_H

#ifdef __METAL__
#include <metal_stdlib>
#define metal_only(expression) expression
#else
#define metal_only(expression)
#endif

#endif /* COMPATIBILITY_H */
