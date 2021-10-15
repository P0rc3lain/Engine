//
//  SceneDescription.swift
//  Types
//
//  Created by Mateusz Stompór on 11/10/2021.
//

public struct SceneDescription<DataType, IndexType, GeometryType, TextureType> {
    // MARK: - Properties
    public var objectNames = [String]()
    public var objects = FlatTree<Entity>()
    public var materialNames = [String]()
    public var materials = [Material<TextureType>]()
    public var meshNames = [String]()
    public var meshes = [Geometry<DataType, IndexType, GeometryType>]()
    public var skeletonReferences = [Int]()
    public var skeletons = [Skeleton]()
    public var skeletalAnimations = [SkeletalAnimation]()
    public var cameraNames = [String]()
    public var cameras = [Camera]()
    public var lightNames = [String]()
    public var lights = [OmniLight]()
    
    // MARK: - Initialization
    public init() { }
}