//
//  Copyright © 2021 Mateusz Stompór. All rights reserved.
//

import ModelIO

public class SceneLoader {
    // MARK: - Properties
    private let assetLoader = AssetLoader()
    private let translator = Translator()
    // MARK: - Initialization
    public init() { }
    // MARK: - Public
    public func resource(from url: URL) -> RamSceneDescription? {
        guard let asset = assetLoader.resource(from: url) else {
            return nil
        }
        return translator.process(asset: asset)
    }
    public func resource(name: String, extension: String, bundle: Bundle) -> RamSceneDescription? {
        guard let asset = assetLoader.resource(name: name, extension: `extension`, bundle: bundle) else {
            return nil
        }
        return translator.process(asset: asset)
    }
}
