//
//  Scene+Instantiation.swift
//  Porcelain
//
//  Created by Mateusz Stompór on 14/11/2020.
//

import simd
import Metal
import Foundation

extension Scene {
    static func make(cameraAspectRation: Float, sceneAsset: SceneAsset) -> Scene {
        let initialOrientation = simd_quatf(angle: 0, axis: simd_float3(0, 1, 0))
        let cameraCoordinateSpace = CoordinateSpace(translation: simd_float3(),
                                                    orientation: initialOrientation,
                                                    scale: simd_float3(1, 1, 1))
        let camera = Camera(nearPlane: 1, farPlane: 10000, fovRadians: Float.radians(80), aspectRation: cameraAspectRation, coordinateSpace: cameraCoordinateSpace)
        return Scene(camera: camera, sceneAsset: sceneAsset)
    }
}
