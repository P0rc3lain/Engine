//
//  Copyright © 2021 Mateusz Stompór. All rights reserved.
//

import ModelIO

/// Convert Model I/O scene asset to a native engine scene.
public protocol PNSceneTranslator {
    func process(asset: MDLAsset) -> PNScene?
}
