//
//  Copyright © 2021 Mateusz Stompór. All rights reserved.
//

import Metal

/// Configures overall look of a model.
public protocol PNMaterial {
    /// Material's identifier.
    var name: String { get }
    /// Base color, RGB-based texture.
    var albedo: MTLTexture { get }
    /// Grey-scale texture.
    var roughness: MTLTexture { get }
    /// Base color, RGB-based texture.
    /// Contains values in tangent-space.
    var normals: MTLTexture { get }
    /// Grey-scale texture.
    var metallic: MTLTexture { get }
    /// Indicates whether or not at least some parts of the model are translucent.
    /// Important for proper ordering and render commands.
    var isTranslucent: Bool { get }
    /// Argument buffer for efficient binding
    var argumentBuffer: MTLBuffer { get }
}
