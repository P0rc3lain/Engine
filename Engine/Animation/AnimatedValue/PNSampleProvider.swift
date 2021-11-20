//
//  Copyright © 2021 Mateusz Stompór. All rights reserved.
//

public protocol PNSampleProvider {
    associatedtype DataType
    func sample(at time: TimeInterval) -> PNAnimationSample<DataType>
}
