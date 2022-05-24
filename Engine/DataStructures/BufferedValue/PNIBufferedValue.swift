//
//  Copyright © 2021 Mateusz Stompór. All rights reserved.
//

final class PNIBufferedValue<T>: PNBufferedValue {
    typealias DataType = T
    private var front: T
    private var back: T
    private var renderFront: Bool
    private let lock = NSLock()
    var pull: T {
        lock.lock()
        let copied = renderFront ? front : back
        lock.unlock()
        return copied
    }
    init(_ front: T, _ back: T, renderFront: Bool = true) {
        self.front = front
        self.back = back
        self.renderFront = renderFront
    }
    func push(_ value: T) {
        lock.lock()
        if renderFront {
            back = value
        } else {
            front = value
        }
        lock.unlock()
    }
    func swap() {
        lock.lock()
        renderFront.toggle()
        lock.unlock()
    }
}
