//
//  Copyright © 2021 Mateusz Stompór. All rights reserved.
//

public struct Node<T> {
    public let parentIdx: Int
    public var data: T
    fileprivate init(parentIdx: Int, data: T) {
        self.parentIdx = parentIdx
        self.data = data
    }
}

public struct FlatTree<T> {
    public var objects = [Node<T>]()
    public var count: Int {
        objects.count
    }
    public var indices: Range<Int> {
        objects.indices
    }
    public init() { }
    public mutating func add(parentIdx: Int, data: T) {
        assert(parentIdx < objects.count && parentIdx >= 0 || parentIdx == Int.nil)
        objects.append(Node<T>(parentIdx: parentIdx, data: data))
    }
    public subscript(index: Int) -> Node<T> {
        objects[index]
    }
    public func children(of idx: Int) -> [Int] {
        objects.filter { node in node.parentIdx == idx }
               .map { node in node.parentIdx }
    }
}
