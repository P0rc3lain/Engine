//
//  Copyright © 2021 Mateusz Stompór. All rights reserved.
//

import ModelIO

//extension MDLSubmesh {
//    var porcelainSubmesh: PNSubmesh? {
//        guard let primitiveType = PNPrimitiveType(modelIO: geometryType),
//              let indexBitDepth = PNIndexBitDepth(modelIO: indexType) else {
//            return nil
//        }
//        let rawBuffer = indexBuffer.rawData
//        let dataBuffer = PNDataBuffer(buffer: rawBuffer, length: rawBuffer.count)
//        return PNSubmesh(indexBuffer: dataBuffer,
//                         indexCount: indexCount,
//                         indexType: indexBitDepth,
//                         primitiveType: primitiveType)
//    }
//}
