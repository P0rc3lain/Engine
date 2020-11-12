//
//  MDLMaterialSemantic.swift
//  Porcelain
//
//  Created by Mateusz Stompór on 12/11/2020.
//

import ModelIO

extension MDLMaterialSemantic {
    var label: String {
        switch self {
        case .baseColor:
            return "albedo"
        case .tangentSpaceNormal:
            return "normal"
        case .emission:
            return "emission"
        case .metallic:
            return "metallic"
        case .roughness:
            return "roughness"
        default:
            fatalError("Not implemented")
        }
    }
}
