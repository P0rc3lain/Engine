//
//  Copyright © 2021 Mateusz Stompór. All rights reserved.
//

/// Converts definition of a hierarchically defined scene into a flat one.
public protocol PNTranscriber {
    func transcribe(scene: PNScene) -> PNSceneDescription
}
