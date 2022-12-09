//
//  Copyright © 2021 Mateusz Stompór. All rights reserved.
//

final class PNAnyBufferedValue<T>: PNBufferedValue {
    typealias DataType = T
    var pull: T {
        pullProxy()
    }
    var pullInactive: T {
        pullInactiveProxy()
    }
    private let pullProxy: () -> T
    private let pullInactiveProxy: () -> T
    private var pushProxy: (T) -> Void
    private var swapProxy: () -> Void
    init<V: PNBufferedValue>(_ value: V) where V.DataType == T {
        pullProxy = { value.pull }
        pullInactiveProxy = { value.pullInactive }
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
