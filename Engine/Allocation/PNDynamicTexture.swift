//
//  Copyright © 2022 Mateusz Stompór. All rights reserved.
//

import Metal

protocol PNDynamicTexture: PNTextureProvider {
    var descriptor: MTLTextureDescriptor? { get set }
    var texture: MTLTexture? { get }
    func updateDescriptor(descriptor: MTLTextureDescriptor?) -> Suceeded
}
