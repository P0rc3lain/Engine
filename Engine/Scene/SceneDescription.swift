//
//  SceneDescription.swift
//  Engine
//
//  Created by Mateusz Stompór on 11/10/2021.
//

import MetalBinding

public struct SceneDescription<DataType, IndexType, GeometryType, TextureType> {
    // MARK: - Properties
    // MARK: - Capacity A
    public var objectNames = [String]()
    public var objects = FlatTree<Entity>()
    public var skeletonReferences = [Int]()
    // MARK: - Capacity B
    public var materialNames = [String]()
    public var materials = [Material<TextureType>]()
    // MARK: - Capacity C
    public var meshNames = [String]()
    public var meshes = [Geometry<DataType, IndexType, GeometryType>]()
    // MARK: - Capacity D
    public var skeletons = [Skeleton]()
    public var paletteReferences = [Range<Int>]()
    // MARK: - Capacity E
    public var skeletalAnimations = [SkeletalAnimation]()
    // MARK: - Capacity F
    public var cameraNames = [String]()
    public var cameras = [Camera]()
    // MARK: - Capacity G
    public var lightNames = [String]()
    public var lights = [OmniLight]()
    // MARK: - Capacity H
    public var skyMaps = [TextureType]()
    // MARK: - Capacity I
    public var activeCameraIdx = Int.nil
    public var sky = Int.nil
    // MARK: - Initialization
    public init() { }
}
