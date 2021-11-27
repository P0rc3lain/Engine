//
//  Copyright © 2021 Mateusz Stompór. All rights reserved.
//

import simd

public protocol PNManageableTransform {
    associatedtype DataType
    func map(_ transfrom: (DataType) -> DataType)
}
