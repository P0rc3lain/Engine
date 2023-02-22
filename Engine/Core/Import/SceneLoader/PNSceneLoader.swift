//
//  Copyright © 2021 Mateusz Stompór. All rights reserved.
//

/// Load entire scene description from a path.
public protocol PNSceneLoader {
    func resource(from url: URL) -> PNScene?
    func resource(name: String, extension: String, bundle: Bundle) -> PNScene?
}
