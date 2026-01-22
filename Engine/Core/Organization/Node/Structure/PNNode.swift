//
//  Copyright © 2021 Mateusz Stompór. All rights reserved.
//

/// Used to create a hierarchical structure of a tree.
/// Built with storing ``PNSceneNode`` in mind, but can be used for any data type.
public final class PNNode<T> {
    public var data: T
    public weak var parent: PNNode?
    public var children: [PNNode]
    init(data: T, parent: PNNode? = nil, children: [PNNode] = []) {
        self.parent = parent
        self.data = data
        self.children = children
    }
    public func add(child: PNNode<T>) {
        assert(!contains(node: child), "Nodes must be unique")
        assertNil(child.parent, "Child must not have parent")
        child.parent = self
        children.append(child)
    }
    public func add(children: PNNode<T>...) {
        assert(!contains(anyNode: children), "Nodes must be unique")
        for child in children {
            add(child: child)
        }
    }
    public func add(children: [PNNode<T>]) {
        assert(!contains(anyNode: children), "Nodes must be unique")
        for child in children {
            add(child: child)
        }
    }
    public func all() -> [PNNode<T>] {
        [self] + children.map { $0.all() }.reduce([], +)
    }
    public func findNode(where closure: (PNNode<T>) -> Bool) -> PNNode<T>? {
        closure(self) ? self : children.compactMap { $0.findNode(where: closure) }.first
    }
    public func findAllNodes(where closure: (PNNode<T>) -> Bool) -> [PNNode<T>] {
        let result = closure(self) ? [self] : []
        return result + children.map { $0.findAllNodes(where: closure) }.reduce([], +)
    }
    public func contains(node: PNNode<T>) -> Bool {
        if self === node {
            return true
        }
        return children.map { $0.contains(node: node) }.first(where: { $0 }) ?? false
    }
    public func contains(anyNode: [PNNode<T>]) -> Bool {
        anyNode.map { contains(node: $0) }.first(where: { $0 }) ?? false
    }
    public func removeSubtree() -> PNNode<T> {
        guard let parent = parent else {
            return self
        }
        parent.children.removeAll(where: { $0 === self })
        return self
    }
}
