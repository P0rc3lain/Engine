//
//  Copyright © 2021 Mateusz Stompór. All rights reserved.
//

import Metal
import MetalBinding

public class PNSceneDescription {
    // MARK: - Capacity A
    public var entities = PNEntityTree()
    public var uniforms = [WModelUniforms]()
    public var boundingBoxes = [PNWBoundingBox]()
    // MARK: - Capacity B
    public var models = [PNModelReference]()
    // MARK: - Capacity C
    public var animatedModels = [PNAnimatedModelReference]()
    public var paletteOffset = [Int]()
    // MARK: - Capacity D
    public var meshes = [PNMesh]()
    // MARK: - Capacity E
    public var skeletons = [PNSkeleton]()
    // MARK: - Capacity F
    public var palettes = [PNM2WTransform]()
    // MARK: - Capacity G
    public var cameras = [PNCamera]()
    public var cameraUniforms = [CameraUniforms]()
    // MARK: - Capacity H
    public var omniLights = [OmniLight]()
    // MARK: - Capacity I
    public var ambientLights = [AmbientLight]()
    // MARK: - Capacity J
    public var directionalLights = [DirectionalLight]()
    // MARK: - Capacity K
    public var spotLights = [SpotLight]()
    // MARK: - Capacity L
    public var skyMap: MTLTexture?
    public var activeCameraIdx = Int.nil
}
