//
//  Model.h
//  Engine
//
//  Created by Mateusz Stompór on 15/10/2021.
//

#ifndef MODEL_H
#define MODEL_H

struct ModelUniforms {
    simd_float4x4 modelMatrix;
    simd_float4x4 modelMatrixInverse;
    simd_float4x4 modelMatrixInverse2;
    simd_float4x4 modelMatrixInverse3;
};

#endif /* MODEL_H */
