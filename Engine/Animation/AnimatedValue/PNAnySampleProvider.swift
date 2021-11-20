//
//  Copyright © 2021 Mateusz Stompór. All rights reserved.
//

public struct PNAnySampleProvider<T>: PNSampleProvider {
    public typealias DataType = T
    private let sampleProxy: (TimeInterval) -> PNAnimationSample<T>
    init<V: PNSampleProvider>(_ delegatee: V) where V.DataType == T {
        sampleProxy = delegatee.sample(at:)
    }
    public func sample(at time: TimeInterval) -> PNAnimationSample<T> {
        sampleProxy(time)
    }
}
