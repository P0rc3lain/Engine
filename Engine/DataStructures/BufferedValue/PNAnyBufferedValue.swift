//
//  Copyright © 2021 Mateusz Stompór. All rights reserved.
//

class PNAnyBufferedValue<T>: PNBufferedValue {
    typealias DataType = T
    var pull: T {
        pullProxy()
    }
    private let pullProxy: () -> T
    private var pushProxy: (T) -> Void
    private var swapProxy: () -> ()
    init<V: PNBufferedValue>(_ value: V) where V.DataType == T {
        pullProxy = { value.pull }
        pushProxy = value.push(_:)
        swapProxy = value.swap
    }
    func push(_ value: T) {
        pushProxy(value)
    }
    func swap() {
        swapProxy()
    }
}
