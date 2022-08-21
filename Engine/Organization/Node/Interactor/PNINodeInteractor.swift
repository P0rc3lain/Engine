//
//  Copyright © 2021 Mateusz Stompór. All rights reserved.
//

public struct PNINodeInteractor: PNNodeInteractor {
    public init() { }
    public func forEach<T>(node: PNNode<T>, _ closure: (PNNode<T>) -> Void) {
        forEach(node: node) { n, _ in closure(n) }
    }
    public func forEach<T, P>(node: PNNode<T>, passingClosure: (PNNode<T>, P?) -> P?) {
        forEach(node: node, passingClosure: passingClosure, initial: nil)
    }
    private func forEach<T, P>(node: PNNode<T>, passingClosure: (PNNode<T>, P?) -> P?, initial: P?) {
        let value = passingClosure(node, initial)
        node.children.forEach {
            forEach(node: $0, passingClosure: passingClosure, initial: value)
        }
    }
    public func deepSearch<T>(from node: PNNode<T>, closure passes: (PNNode<T>) -> Bool) -> [PNNode<T>] {
        var total = [PNNode<T>]()
        if passes(node) {
            if !node.children.isEmpty {
                total += node.children.flatMap({ deepSearch(from: $0, closure: passes) })
            }
            total += total.isEmpty ? [node] : []
        } else if let parent = node.parent, passes(parent) {
            total += [parent]
        }
        return total
    }
}
