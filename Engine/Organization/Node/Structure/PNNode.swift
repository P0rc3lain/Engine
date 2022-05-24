//
//  Copyright © 2021 Mateusz Stompór. All rights reserved.
//

public final class PNNode<T> {
    public var data: T
    public weak var parent: PNNode?
    public var children: [PNNode]
    public init(data: T, parent: PNNode? = nil, children: [PNNode] = []) {
        self.data = data
        self.parent = parent
        self.children = children
    }
    public func add(child: PNNode<T>) {
        child.parent = self
        children.append(child)
    }
    public func add(children: [PNNode<T>]) {
        for child in children {
            add(child: child)
        }
    }
}
