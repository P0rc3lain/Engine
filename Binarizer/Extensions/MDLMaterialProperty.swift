//
//  MDLMaterialProperty.swift
//  Binarizer
//
//  Created by Mateusz Stompór on 12/10/2021.
//

import ModelIO

extension MDLMaterialProperty {
    var associatedTexture: MDLTexture? {
        if let sourceTexture = textureSamplerValue?.texture {
            return sourceTexture
        } else if let stringValue = stringValue, let filename = stringValue.split(separator: "/").last {
            return MDLTexture(named: String(filename))
        }
        return nil
    }
}
