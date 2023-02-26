//
//  Copyright © 2022 Mateusz Stompór. All rights reserved.
//

/// An interface meant to use for tree structure debugging.
/// The aim is to print out messages about each node while traversing the structure.
public protocol PNNodeTrace {
    func tree<T>(node: PNNode<T>, transform: (PNNode<T>) -> String) -> String
}
