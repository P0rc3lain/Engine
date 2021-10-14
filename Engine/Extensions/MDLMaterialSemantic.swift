//
//  MDLMaterialSemantic.swift
//  Engine
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
        case .metallic:
            return "metallic"
        case .roughness:
            return "roughness"
        case .specularExponent:
            return "specularExponent"
        case .bump:
            return "bump"
        default:
            fatalError("Not implemented")
        }
    }
}
