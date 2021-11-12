//
//  Copyright © 2021 Mateusz Stompór. All rights reserved.
//

#ifndef SSAO_H
#define SSAO_H

struct SSAOUniforms {
    int sampleCount;
    int noiseCount;
    float radius;
    float bias;
    float power;
};

#endif /* SSAO_H */
