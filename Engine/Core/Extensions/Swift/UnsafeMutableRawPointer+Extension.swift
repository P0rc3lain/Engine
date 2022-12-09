//
//  Copyright © 2021 Mateusz Stompór. All rights reserved.
//

extension UnsafeMutableRawPointer {
    func copyBuffer(from source: UnsafeRawBufferPointer) {
        guard let baseAddress = source.baseAddress else {
            fatalError("Cannot retrieve base address of the pointer")
        }
        copyMemory(from: baseAddress, byteCount: source.count)
    }
}
