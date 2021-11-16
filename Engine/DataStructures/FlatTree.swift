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
    private var objects: [Node<T>]
    public var count: Int {
        objects.count
    }
    public var indices: Range<Int> {
        objects.indices
    }
    public var isEmpty: Bool {
        objects.isEmpty
    }
    public init() {
        objects = []
    }
    public mutating func add(parentIdx: Int, data: T) {
        assert(parentIdx < objects.count, "Parent index if non-nil \(Int.nil) must refer to an exisitng node")
        assert(parentIdx >= Int.nil, "Parent index value cannot be lower than 0 or different than \(Int.nil)")
        objects.append(Node<T>(parentIdx: parentIdx, data: data))
    }
    public subscript(index: Int) -> Node<T> {
        get {
            objects[index]
        } set {
            objects[index] = newValue
        }
    }
    public func children(of idx: Int) -> [Int] {
        objects.indices.filter { objects[$0].parentIdx == idx }
    }
}
