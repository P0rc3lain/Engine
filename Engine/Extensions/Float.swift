//
//  Float.swift
//  Porcelain
//
//  Created by Mateusz Stompór on 06/11/2020.
//

public extension Float {
    var radians: Float {
        Float.radians(self)
    }
    var degress: Float {
        Float.degress(self)
    }
    static func radians(_ degrees: Float) -> Float {
        degrees * .pi / 180
    }
    static func degress(_ radians: Float) -> Float {
        radians * 180 / .pi
    }
}
