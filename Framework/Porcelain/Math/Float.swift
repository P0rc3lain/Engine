//
//  Float.swift
//  Porcelain
//
//  Created by Mateusz Stompór on 06/11/2020.
//

public extension Float {
    var radians: Float {
        get {
            return Float.radians(self)
        }
    }
    var degress: Float {
        get {
            return Float.degress(self)
        }
    }
    static func radians(_ degrees: Float) -> Float {
        return degrees * .pi / 180
    }
    static func degress(_ radians: Float) -> Float {
        return radians * 180 / .pi
    }
}
