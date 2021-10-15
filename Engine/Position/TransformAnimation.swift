//
//  TransformAnimation.swift
//  Types
//
//  Created by Mateusz Stompór on 11/10/2021.
//

public struct TransformAnimation {
    // MARK: - Properties
    public let minimumTime: TimeInterval
    public let maximumTime: TimeInterval
    public let keyTimes: [TimeInterval]
    public let keyFrames: [CoordinateSpace]
    // MARK: - Initialization
    public init(minimumTime: TimeInterval = 0, maximumTime: TimeInterval = 0,
                keyTimes: [TimeInterval] = [], keyFrames: [CoordinateSpace] = []) {
        self.minimumTime = minimumTime
        self.maximumTime = maximumTime
        self.keyTimes = keyTimes
        self.keyFrames = keyFrames
    }
}
