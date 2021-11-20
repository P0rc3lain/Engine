//
//  Copyright © 2021 Mateusz Stompór. All rights reserved.
//

import ModelIO

extension MDLSubmesh {
    var porcelainSubmesh: PNRamSubmesh? {
        guard let primitiveType = PNPrimitiveType(modelIO: geometryType),
              let indexBitDepth = PNIndexBitDepth(modelIO: indexType) else {
            return nil
        }
        let rawBuffer = indexBuffer.rawData
        let dataBuffer = PNDataBuffer(buffer: rawBuffer, length: rawBuffer.count)
        return PNRamSubmesh(indexBuffer: dataBuffer,
                          indexCount: indexCount,
                          indexType: indexBitDepth,
                          primitiveType: primitiveType)
    }
}
