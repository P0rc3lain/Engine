//
//  RawRepresentable+Extension.swift
//  RawRepresentable+Extension
//
//  Created by Mateusz Stompór on 22/10/2021.
//

import MetalBinding

extension RawRepresentable where RawValue == UInt32 {
    var int: Int {
        Int(rawValue)
    }
}
