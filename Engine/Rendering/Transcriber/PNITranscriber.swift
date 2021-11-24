//
//  Copyright © 2021 Mateusz Stompór. All rights reserved.
//

struct PNITranscriber: PNTranscriber {
    func transcribe(scene: PNScene) -> PNSceneDescription {
        var sceneDescription = PNSceneDescription()
        write(node: scene.rootNode, scene: &sceneDescription, parentIndex: .nil)
        return sceneDescription
    }
    private func write(node: PNNode<PNSceneNode>, scene: inout PNSceneDescription, parentIndex: PNIndex) {
        let index = node.data.write(scene: &scene, parentIdx: parentIndex)
        for child in node.children {
            write(node: child, scene: &scene, parentIndex: index)
        }
    }
}
