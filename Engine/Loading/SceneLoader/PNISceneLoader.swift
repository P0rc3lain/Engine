//
//  Copyright © 2021 Mateusz Stompór. All rights reserved.
//

import ModelIO
import Metal

public class PNISceneLoader: PNSceneLoader {
    private let assetLoader: PNAssetLoader
    private let translator: PNTranslator
    init(device: MTLDevice, assetLoader: PNAssetLoader, translator: PNTranslator) {
        self.translator = translator
        self.assetLoader = assetLoader
    }
    public func resource(from url: URL) -> PNSceneDescription? {
        guard let asset = assetLoader.resource(from: url) else {
            return nil
        }
        return translator.process(asset: asset)
    }
    public func resource(name: String, extension: String, bundle: Bundle) -> PNSceneDescription? {
        guard let asset = assetLoader.resource(name: name, extension: `extension`, bundle: bundle) else {
            return nil
        }
        return translator.process(asset: asset)
    }
}
