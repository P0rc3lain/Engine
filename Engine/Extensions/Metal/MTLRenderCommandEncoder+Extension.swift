//
//  Copyright © 2021 Mateusz Stompór. All rights reserved.
//

import Metal

extension MTLRenderCommandEncoder {
    func setVertexBuffer(_ buffer: MTLBuffer?, index: Int) {
        setVertexBuffer(buffer, offset: 0, index: index)
    }
    func setFragmentBuffer(_ buffer: MTLBuffer?, index: Int) {
        setFragmentBuffer(buffer, offset: 0, index: index)
    }
    func setFragmentTextures(_ textures: [MTLTexture?], range: ClosedRange<Int>) {
        setFragmentTextures(textures, range: Range(range))
    }
}
