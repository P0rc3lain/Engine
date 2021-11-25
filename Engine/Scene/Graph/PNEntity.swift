//
//  Copyright © 2021 Mateusz Stompór. All rights reserved.
//

public struct PNEntity {
    public var transform: PNAnimatedCoordinateSpace
    public let type: PNEntityType
    public let referenceIdx: PNIndex
    public init(transform: PNAnimatedCoordinateSpace,
                type: PNEntityType,
                referenceIdx: PNIndex) {
        self.transform = transform
        self.type = type
        self.referenceIdx = referenceIdx
    }
}
