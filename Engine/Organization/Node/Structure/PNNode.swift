//
//  Copyright © 2021 Mateusz Stompór. All rights reserved.
//

import Combine

public final class PNNode<T> {
    public var dataSubject: CurrentValueSubject<T, Error>
    public var data: T {
        get {
            dataSubject.value
        } set {
            dataSubject.send(newValue)
        }
    }
    public var parentSubject: CurrentValueSubject<PNWeakRef<PNNode>, Error>
    public weak var parent: PNNode? {
        get {
            parentSubject.value.reference
        } set {
            parentSubject.send(PNWeakRef(newValue))
        }
    }
    public var childrenSubject: CurrentValueSubject<[PNNode], Error>
    public var children: [PNNode] {
        get {
            childrenSubject.value
        } set {
            childrenSubject.send(newValue)
        }
    }
    init(data: T, parent: PNNode? = nil, children: [PNNode] = []) {
        parentSubject = CurrentValueSubject<PNWeakRef<PNNode>, Error>(PNWeakRef(parent))
        dataSubject = CurrentValueSubject<T, Error>(data)
        childrenSubject = CurrentValueSubject<[PNNode], Error>(children)
    }
    public func add(child: PNNode<T>) {
        assert(!contains(node: child), "Nodes must be unique")
        assert(child.parent == nil, "Child must not have parent")
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
    public func contains(node: PNNode<T>) -> Bool {
        if self === node {
            return true
        }
        return children.map { $0.contains(node: node) }.filter { $0 }.first ?? false
    }
    public func contains(anyNode: [PNNode<T>]) -> Bool {
        return anyNode.map{ contains(node: $0) }.filter { $0 }.first ?? false
    }
}
