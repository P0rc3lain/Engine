//
//  Copyright © 2021 Mateusz Stompór. All rights reserved.
//

import ModelIO

public protocol PNSceneTranslator {
    func process(asset: MDLAsset) -> PNScene?
}
