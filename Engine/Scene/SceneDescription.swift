//
//  Copyright © 2021 Mateusz Stompór. All rights reserved.
//

import MetalBinding

public struct SceneDescription<DataType, IndexType, GeometryType, TextureType> {
    // MARK: - Capacity A
    public var entityNames = [String]()
    public var entities = FlatTree<Entity>()
    public var skeletonReferences = [Int]()
    // MARK: - Capacity B
    public var materialNames = [String]()
    public var materials = [Material<TextureType>]()
    // MARK: - Capacity C
    public var meshNames = [String]()
    public var meshBuffers = [DataBuffer<DataType>]()
    public var indexDrawReferences = [Range<Int>]()
    // MARK: - Capacity D
    public var indexDraws = [IndexBasedDraw<DataType, IndexType, GeometryType>]()
    public var indexDrawsMaterials = [Int]()
    // MARK: - Capacity E
    public var skeletons = [Skeleton]()
    public var paletteReferences = [Range<Int>]()
    public var animationReferences = [Range<Int>]()
    // MARK: - Capacity F
    public var skeletalAnimations = [AnimatedSkeleton]()
    // MARK: - Capacity G
    public var cameraNames = [String]()
    public var cameras = [Camera]()
    // MARK: - Capacity H
    public var omniLightNames = [String]()
    public var omniLights = [OmniLight]()
    // MARK: - Capacity I
    public var ambientLightNames = [String]()
    public var ambientLights = [AmbientLight]()
    // MARK: - Capacity J
    public var skyMaps = [TextureType]()
    // MARK: - Capacity K
    public var activeCameraIdx = Int.nil
    public var sky = Int.nil
    public init() { }
}
