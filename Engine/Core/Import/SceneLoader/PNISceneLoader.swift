//
//  Copyright © 2021 Mateusz Stompór. All rights reserved.
//

import Metal
import ModelIO

public final class PNISceneLoader: PNSceneLoader {
    private let assetLoader: PNAssetLoader
    private let translator: PNSceneTranslator
    public init(device: MTLDevice,
                assetLoader: PNAssetLoader,
                translator: PNSceneTranslator) {
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
        let resourceRetrieval = psignposter.beginInterval("Resource retrieval")
        guard let asset = assetLoader.resource(name: name, extension: `extension`, bundle: bundle) else {
            return nil
        }
        psignposter.endInterval("Resource retrieval", resourceRetrieval)
        let sceneTranslation = psignposter.beginInterval("Scene translation")
        let processedScene = translator.process(asset: asset)
        psignposter.endInterval("Scene translation", sceneTranslation)
        return processedScene
    }
    public static func `default`(device: MTLDevice) -> PNISceneLoader {
        PNISceneLoader(device: device,
                       assetLoader: PNIAssetLoader(),
                       translator: PNISceneTranslator(device: device))
    }
}
