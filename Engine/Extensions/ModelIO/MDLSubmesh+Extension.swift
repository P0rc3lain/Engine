//
//  Copyright © 2021 Mateusz Stompór. All rights reserved.
//

import ModelIO

extension MDLSubmesh {
    var porcelainIndexBasedDraw: RamIndexBasedDraw? {
        guard let primitiveType = PrimitiveType(modelIO: geometryType),
              let indexBitDepth = IndexBitDepth(modelIO: indexType) else {
            return nil
        }
        let rawBuffer = indexBuffer.rawData
        let dataBuffer = DataBuffer(buffer: rawBuffer, length: rawBuffer.count)
        return IndexBasedDraw(indexBuffer: dataBuffer,
                              indexCount: indexCount,
                              indexType: indexBitDepth,
                              primitiveType: primitiveType)
    }
}
