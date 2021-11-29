//
//  Copyright © 2021 Mateusz Stompór. All rights reserved.
//

import MetalBinding
import Metal

public class PNSceneDescription {
    // MARK: - Capacity A
    public var entities = PNEntityTree()
    public var uniforms = [WModelUniforms]()
    public var boundingBoxes = [PNWBoundingBox]()
    public var skeletonReferences = [PNIndex]()
    // MARK: - Capacity B
    public var meshes = [PNMesh]()
    // MARK: - Capacity C
    public var skeletons = [PNSkeleton]()
    public var paletteOffset = [Int]()
    // MARK: - Capacity D
    public var palettes = [PNM2WTransform]()
    // MARK: - Capacity E
    public var cameras = [PNCamera]()
    public var cameraUniforms = [CameraUniforms]()
    // MARK: - Capacity F
    public var omniLights = [OmniLight]()
    // MARK: - Capacity G
    public var ambientLights = [AmbientLight]()
    // MARK: - Capacity H
    public var directionalLights = [DirectionalLight]()
    // MARK: - Capacity I
    public var spotLights = [SpotLight]()
    // MARK: - Capacity J
    public var skyMap: MTLTexture? = nil
    public var activeCameraIdx = Int.nil
}
