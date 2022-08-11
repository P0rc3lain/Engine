//
//  Copyright © 2021 Mateusz Stompór. All rights reserved.
//

import Metal

protocol PNStaticBuffer {
    associatedtype DataType
    var buffer: MTLBuffer { get }
    func upload(data: [DataType])
    func upload(value: DataType)
}
