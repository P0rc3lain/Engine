//
//  Compatibility.h
//  Types
//
//  Created by Mateusz Stompór on 14/10/2021.
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
