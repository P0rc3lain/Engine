//
//  Copyright © 2022 Mateusz Stompór. All rights reserved.
//

#pragma once

enum FunctionConstantIndexOmniShadow {
    kFunctionConstantOmniShadowHasSkeleton = 0
};

enum FunctionConstantIndexSpotShadow {
    kFunctionConstantSpotShadowHasSkeleton = 0
};

enum FunctionConstantIndexDirectionalShadow {
    kFunctionConstantDirectionalShadowHasSkeleton = 0
};

enum FunctionConstantIndexGBuffer {
    kFunctionConstantGBufferHasSkeleton = 0
};

enum FunctionConstantIndexTranslucent {
    kFunctionConstantTranslucentHasSkeleton = 0
};

enum FunctionConstantIndexOmni {
    kFunctionConstantIndexOmniPcfRange = 0,
    kFunctionConstantIndexOmniShadowBias
};

enum FunctionConstantIndexDirectional {
    kFunctionConstantIndexDirectionalPcfRange = 0,
    kFunctionConstantIndexDirectionalShadowBias
};

enum FunctionConstantIndexBloom {
    kFunctionConstantIndexBloomThreshold = 0,
    kFunctionConstantIndexBloomAmplification
};

enum FunctionConstantIndexSSAO {
    kFunctionConstantIndexSSAOSampleCount = 0
};
