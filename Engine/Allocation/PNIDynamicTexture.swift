//
//  Copyright © 2022 Mateusz Stompór. All rights reserved.
//

import Metal

class PNIDynamicTexture: PNDynamicTexture {
    var texture: MTLTexture?
    private let device: MTLDevice
    private var descriptorValue: MTLTextureDescriptor?
    var descriptor: MTLTextureDescriptor? {
        set {
            if newValue != descriptorValue {
                descriptorValue = newValue
                if let newDescriptor = newValue {
                    texture = device.makeTexture(descriptor: newDescriptor)
                }
            }
        } get {
            return descriptorValue
        }
    }
    init(device: MTLDevice, descriptor: MTLTextureDescriptor? = nil) {
        self.texture = nil
        self.descriptorValue = nil
        self.device = device
        self.descriptor = descriptor
    }
    func updateDescriptor(descriptor: MTLTextureDescriptor?) -> Bool {
        var before = descriptorValue
        self.descriptor = descriptor
        return before != descriptorValue
    }
}
