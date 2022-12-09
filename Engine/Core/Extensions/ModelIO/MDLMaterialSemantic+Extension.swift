//
//  Copyright © 2021 Mateusz Stompór. All rights reserved.
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
            return .defaultBaseColor
        case .tangentSpaceNormal, .bump:
            return .defaultNormalsColor
        case .roughness, .specularExponent:
            return .defaultRoughnessColor
        case .metallic:
            return .defaultMetallicColor
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
