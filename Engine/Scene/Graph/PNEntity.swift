//
//  Copyright © 2021 Mateusz Stompór. All rights reserved.
//

public struct PNEntity {
    public let type: PNEntityType
    public let referenceIdx: PNIndex
    public init(type: PNEntityType,
                referenceIdx: PNIndex) {
        self.type = type
        self.referenceIdx = referenceIdx
    }
}
