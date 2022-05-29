//
//  Copyright © 2021 Mateusz Stompór. All rights reserved.
//

public protocol PNTranscriber {
    func transcribe(scene: PNScene) -> PNSceneDescription
}
