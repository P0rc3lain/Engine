//
//  Copyright © 2021 Mateusz Stompór. All rights reserved.
//

import Metal
import ModelIO

public class PNISceneLoader: PNSceneLoader {
    private let assetLoader: PNAssetLoader
    private let translator: PNSceneTranslator
    public init(device: MTLDevice, assetLoader: PNAssetLoader, translator: PNSceneTranslator) {
        self.translator = translator
        self.assetLoader = assetLoader
    }
    public func resource(from url: URL) -> PNScene? {
        guard let asset = assetLoader.resource(from: url) else {
            return nil
        }
        return translator.process(asset: asset)
    }
    public func resource(name: String, extension: String, bundle: Bundle) -> PNScene? {
        guard let asset = assetLoader.resource(name: name, extension: `extension`, bundle: bundle) else {
            return nil
        }
        return translator.process(asset: asset)
    }
}
