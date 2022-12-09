//
//  Copyright © 2022 Mateusz Stompór. All rights reserved.
//

public protocol PNNodeTrace {
    func tree<T>(node: PNNode<T>, transform: (PNNode<T>) -> String) -> String
}
