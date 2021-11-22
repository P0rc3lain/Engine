//
//  Copyright © 2021 Mateusz Stompór. All rights reserved.
//

import ModelIO

protocol PNAssetLoader {
    func resource(from url: URL) -> MDLAsset?
    func resource(name: String, extension: String, bundle: Bundle) -> MDLAsset?
}
