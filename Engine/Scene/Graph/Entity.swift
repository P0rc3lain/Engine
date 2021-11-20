//
//  Copyright © 2021 Mateusz Stompór. All rights reserved.
//

public struct Entity {
    public var transform: PNAnimatedCoordinateSpace
    public let type: EntityType
    public let referenceIdx: Int
    public init(transform: PNAnimatedCoordinateSpace,
                type: EntityType,
                referenceIdx: Int) {
        self.transform = transform
        self.type = type
        self.referenceIdx = referenceIdx
    }
}
