//
//  Copyright © 2021 Mateusz Stompór. All rights reserved.
//

import MetalBinding

public struct SceneDescription<DataType, IndexType, GeometryType, TextureType> {
    // MARK: - Capacity A
    public var entityNames = [String]()
    public var entities = FlatTree<Entity>()
    public var skeletonReferences = [Int]()
    // MARK: - Capacity C
    public var meshes = [PNMesh<DataType, IndexType, GeometryType>]()
    var meshBoundingBoxes = [BoundingBox]()
    // MARK: - Capacity E
    var skeletons = [PNSkeleton]()
    public var paletteReferences = [Range<Int>]()
    public var animationReferences = [Range<Int>]()
    // MARK: - Capacity F
    public var skeletalAnimations = [PNAnimatedSkeleton]()
    // MARK: - Capacity G
    public var cameras = [Camera]()
    // MARK: - Capacity H
    public var omniLightNames = [String]()
    public var omniLights = [OmniLight]()
    // MARK: - Capacity I
    public var ambientLightNames = [String]()
    public var ambientLights = [AmbientLight]()
    // MARK: - Capacity J
    public var directionalLightNames = [String]()
    public var directionalLights = [DirectionalLight]()
    // MARK: - Capacity K
    public var spotLightNames = [String]()
    public var spotLights = [SpotLight]()
    // MARK: - Capacity L
    public var skyMaps = [TextureType]()
    // MARK: - Capacity M
    public var activeCameraIdx = Int.nil
    public var sky = Int.nil
    public init() { }
}
