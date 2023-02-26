//
//  Copyright © 2021 Mateusz Stompór. All rights reserved.
//

/// Performing generalized operations on nodes.
public protocol PNNodeInteractor {
    func forEach<T>(node: PNNode<T>, _ closure: (PNNode<T>) -> Void)
    func forEach<T, P>(node: PNNode<T>, passingClosure: (PNNode<T>, P?) -> P?)
    func deepSearch<T>(from: PNNode<T>, closure: (PNNode<T>) -> Bool) -> [PNNode<T>]
}
