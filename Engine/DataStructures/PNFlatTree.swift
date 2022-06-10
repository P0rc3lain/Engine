//
//  Copyright © 2021 Mateusz Stompór. All rights reserved.
//

public struct PNFlatTreeNode<T> {
    public let parentIdx: PNIndex
    public var data: T
    fileprivate init(parentIdx: PNIndex, data: T) {
        self.parentIdx = parentIdx
        self.data = data
    }
}

public struct PNFlatTree<T> {
    private var objects: [PNFlatTreeNode<T>]
    public var count: Int {
        objects.count
    }
    public var indices: Range<PNIndex> {
        objects.indices
    }
    public var isEmpty: Bool {
        objects.isEmpty
    }
    public init() {
        objects = []
    }
    public mutating func add(parentIdx: PNIndex, data: T) {
        assert(parentIdx < objects.count,
               "Parent index if non-nil \(Int.nil) must refer to an exisitng node")
        assert(parentIdx >= Int.nil,
               "Parent index value cannot be lower than 0 or different than \(Int.nil)")
        objects.append(PNFlatTreeNode(parentIdx: parentIdx, data: data))
    }
    public subscript(index: PNIndex) -> PNFlatTreeNode<T> {
        get {
            objects[index]
        } set {
            objects[index] = newValue
        }
    }
    public func children(of idx: PNIndex) -> [PNIndex] {
        objects.indices.filter { objects[$0].parentIdx == idx }
    }
    public func descendants(of idx: PNIndex) -> [PNIndex] {
        let nearChildren = children(of: idx)
        return nearChildren + nearChildren.map { descendants(of: $0) }.flatMap({ $0 })
    }
}
