//
//  MTLViewport+Extension.swift
//  Engine
//
//  Created by Mateusz Stompór on 23/10/2021.
//

import Metal

extension MTLViewport {
    static func porcelain(size: CGSize) -> MTLViewport {
        MTLViewport(originX: 0,
                    originY: 0,
                    width: Double(size.width),
                    height: Double(size.height),
                    znear: 0,
                    zfar: 1)
    }
}
