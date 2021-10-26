//
//  Copyright © 2021 Mateusz Stompór. All rights reserved.
//

import ModelIO

extension MDLMeshBuffer {
    var rawData: Data {
        return Data(bytes: map().bytes, count: length)
    }
}
