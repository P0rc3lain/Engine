//
//  Copyright © 2021 Mateusz Stompór. All rights reserved.
//

import Metal

public protocol PNMaterial: Identifiable {
    var albedo: MTLTexture { get }
    var roughness: MTLTexture { get }
    var normals: MTLTexture { get }
    var metallic: MTLTexture { get }
}
