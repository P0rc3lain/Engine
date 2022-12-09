//
//  Copyright © 2021 Mateusz Stompór. All rights reserved.
//

import ModelIO

extension MDLMaterialProperty {
    var associatedTexture: MDLTexture? {
        if let sourceTexture = textureSamplerValue?.texture {
            return sourceTexture
        } else if let stringValue = stringValue,
                  let filename = stringValue.split(separator: "/").last {
            return MDLTexture(named: String(filename))
        }
        return nil
    }
}
