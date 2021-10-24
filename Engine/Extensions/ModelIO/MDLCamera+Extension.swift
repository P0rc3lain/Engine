//
//  MDLCamera.swift
//  Engine
//
//  Created by Mateusz Stompór on 13/10/2021.
//

import ModelIO

extension MDLCamera {
    var porcelain: Camera {
        Camera(nearPlane: nearVisibilityDistance,
               farPlane: farVisibilityDistance,
               fovRadians: fieldOfView.radians,
               aspectRation: sensorAspect)
    }
}
