//
//  Copyright © 2021 Mateusz Stompór. All rights reserved.
//

public protocol PNAnimatedValue: PNSampleProvider, PNManageableTransform {
    associatedtype DataType
    var keyFrames: [DataType] { get }
    var times: [TimeInterval] { get }
    var maximumTime: TimeInterval { get }
}
