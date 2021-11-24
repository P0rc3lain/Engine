//
//  Copyright © 2021 Mateusz Stompór. All rights reserved.
//

struct PNINodeInteractor: PNNodeInteractor {
    func forEach<T>(node: PNNode<T>, _ closure: (PNNode<T>) -> Void) {
        forEach(node: node) { n, _ in closure(n) }
    }
    func forEach<T, P>(node: PNNode<T>, passingClosure: (PNNode<T>, P?) -> P?) {
        forEach(node: node, passingClosure: passingClosure, initial: nil)
    }
    private func forEach<T, P>(node: PNNode<T>, passingClosure: (PNNode<T>, P?) -> P?, initial: P?) {
        let value = passingClosure(node, initial)
        for child in node.children {
            forEach(node: child, passingClosure: passingClosure, initial: value)
        }
    }
}
