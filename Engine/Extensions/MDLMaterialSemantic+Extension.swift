//
//  MDLMaterialSemantic.swift
//  Binarizer
//
//  Created by Mateusz Stompór on 12/10/2021.
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
    var defaultColor: simd_float4 {
        switch self {
        case .baseColor:
            return simd_float4.deafultBaseColor
        case .tangentSpaceNormal, .bump:
            return simd_float4.deafultNormalsColor
        case .roughness, .specularExponent:
            return simd_float4.deafultRoughnessColor
        case .metallic:
            return simd_float4.defaultMetallicColor
        default:
            fatalError("Default for \(self) not provided")
        }
    }
    var aliases: [MDLMaterialSemantic] {
        switch self {
        case .roughness:
            return [.roughness, .specularExponent]
        default:
            return [self]
        }
    }
}
