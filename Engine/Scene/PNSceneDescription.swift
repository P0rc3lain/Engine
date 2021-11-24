//
//  Copyright © 2021 Mateusz Stompór. All rights reserved.
//

import MetalBinding
import Metal

public struct PNSceneDescription {
    // MARK: - Capacity A
    public var entities = FlatTree<Entity>()
    public var skeletonReferences = [Int]()
    // MARK: - Capacity C
    public var meshes = [PNMesh]()
    // MARK: - Capacity E
    public var skeletons = [PNSkeleton]()
    public var paletteReferences = [Range<Int>]()
    // MARK: - Capacity G
    public var cameras = [PNCamera]()
    // MARK: - Capacity H
    public var omniLights = [OmniLight]()
    // MARK: - Capacity I
    public var ambientLights = [AmbientLight]()
    // MARK: - Capacity J
    public var directionalLights = [DirectionalLight]()
    // MARK: - Capacity K
    public var spotLights = [SpotLight]()
    // MARK: - Capacity L
    public var skyMaps = [MTLTexture]()
    // MARK: - Capacity M
    public var activeCameraIdx = Int.nil
    public var sky = Int.nil
    init() { }
}
