//
//  Copyright © 2022 Mateusz Stompór. All rights reserved.
//

import Metal

protocol PNDynamicTexture: PNTextureProvider {
    var descriptor: MTLTextureDescriptor? { set get }
    var texture: MTLTexture? { get }
}
