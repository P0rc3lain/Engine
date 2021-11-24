//
//  Copyright © 2021 Mateusz Stompór. All rights reserved.
//

class PNNode<T> {
    var data: T
    var parent: PNNode?
    var children: [PNNode]
    init(data: T, parent: PNNode? = nil, children: [PNNode] = []) {
        self.data = data
        self.parent = parent
        self.children = children
    }
}
