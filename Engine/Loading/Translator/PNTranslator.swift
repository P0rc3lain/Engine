//
//  Copyright © 2021 Mateusz Stompór. All rights reserved.
//

import ModelIO

public protocol PNTranslator {
    func process(asset: MDLAsset) -> GPUSceneDescription?
}
