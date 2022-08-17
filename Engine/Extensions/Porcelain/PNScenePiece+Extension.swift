//
//  Copyright © 2022 Mateusz Stompór. All rights reserved.
//

public extension PNScenePiece {
    static func make(data: PNSceneNode,
                     parent: PNScenePiece? = nil,
                     children: [PNScenePiece] = []) -> PNScenePiece {
        let node = PNScenePiece(data: data, parent: parent, children: children)
        node.data.enclosingNode.send(PNWeakRef(node))
        return node
    }
}
