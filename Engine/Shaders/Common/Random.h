//
//  Copyright © 2021 Mateusz Stompór. All rights reserved.
//

#pragma once

class Random {
private:
    thread float seed;
    unsigned TausStep(const unsigned z,
                      const int s1,
                      const int s2,
                      const int s3,
                      const unsigned M);

public:
    thread Random(const unsigned seed1,
                  const unsigned seed2 = 1,
                  const unsigned seed3 = 1);
    thread float random();
};
