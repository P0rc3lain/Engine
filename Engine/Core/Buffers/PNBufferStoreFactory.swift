//
//  Copyright © 2022 Mateusz Stompór. All rights reserved.
//

/// Builds a new ``PNBufferStore`` when requested.
public protocol PNBufferStoreFactory {
    func new() -> PNBufferStore?
}
