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
    public init(data: T, parent: PNNode? = nil, children: [PNNode] = []) {
        parentSubject = CurrentValueSubject<PNWeakRef<PNNode>, Error>(PNWeakRef(parent))
        dataSubject = CurrentValueSubject<T, Error>(data)
        childrenSubject = CurrentValueSubject<[PNNode], Error>(children)
    }
    public func add(child: PNNode<T>) {
        child.parent = self
        children.append(child)
    }
    public func add(children: PNNode<T>...) {
        for child in children {
            add(child: child)
        }
    }
    public func add(children: [PNNode<T>]) {
        for child in children {
            add(child: child)
        }
    }
}
