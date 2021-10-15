//
//  Float.swift
//  Types
//
//  Created by Mateusz Stompór on 11/10/2021.
//

extension Float {
    // MARK: - Properties
    public var radians: Float {
        self / Float(180) * Float.pi
    }
}
