//
//  Copyright © 2021 Mateusz Stompór. All rights reserved.
//

/// Provides animation samples based on criterion used.
public protocol PNSampleProvider {
    func sample<T>(animation: PNKeyframeAnimation<T>,
                   at time: PNTimePoint) -> PNAnimationSample<T>
}
