//
//  Copyright © 2021 Mateusz Stompór. All rights reserved.
//

public protocol PNSceneLoader {
    func resource(from url: URL) -> GPUSceneDescription?
    func resource(name: String, extension: String, bundle: Bundle) -> GPUSceneDescription?
}
