//
//  Copyright © 2021 Mateusz Stompór. All rights reserved.
//

#pragma once

#include "Pose.h"
#include "../../MetalBinding/Vertex.h"

float4 calculatePosition(Vertex in, constant metal::float4x4 * matrixPalettes);
Pose calculatePose(Vertex in, constant metal::float4x4 * matrixPalettes);
