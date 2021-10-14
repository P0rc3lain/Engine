//
//  Compatibility.h
//  Demo
//
//  Created by Mateusz Stompór on 09/11/2020.
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
