//
//  Copyright © 2021 Mateusz Stompór. All rights reserved.
//

protocol PNBufferedValue {
    associatedtype DataType
    var pull: DataType { get }
    var pullInactive: DataType { get }
    func push(_ value: DataType)
    func swap()
}
