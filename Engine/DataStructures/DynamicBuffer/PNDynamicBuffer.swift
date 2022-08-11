//
//  Copyright © 2021 Mateusz Stompór. All rights reserved.
//

import Metal

protocol PNDynamicBuffer {
    associatedtype DataType
    var buffer: MTLBuffer { get }
    var pulled: [DataType] { get }
    var count: Int { get }
    func upload(data: [DataType])
    func upload(data: DataType)
}
