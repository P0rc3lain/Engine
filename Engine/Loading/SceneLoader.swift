//
//  Copyright © 2021 Mateusz Stompór. All rights reserved.
//

import ModelIO
import Metal

public class SceneLoader {
    private let assetLoader = AssetLoader()
    private let translator: Translator
    public init(device: MTLDevice) {
        self.translator = Translator(device: device)
    }
    public func resource(from url: URL) -> GPUSceneDescription? {
        guard let asset = assetLoader.resource(from: url) else {
            return nil
        }
        return translator.process(asset: asset)
    }
    public func resource(name: String, extension: String, bundle: Bundle) -> GPUSceneDescription? {
        guard let asset = assetLoader.resource(name: name, extension: `extension`, bundle: bundle) else {
            return nil
        }
        return translator.process(asset: asset)
    }
}
