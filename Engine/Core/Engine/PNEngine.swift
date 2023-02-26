//
//  Copyright © 2021 Mateusz Stompór. All rights reserved.
//

import CoreGraphics

/// The main class that the user is supposed to use in order to interact with the engine and its subcomponents.
public protocol PNEngine {
    var scene: PNScene { get set }
    var taskQueue: PNRepeatableTaskQueue { get }
    func draw()
    func update(drawableSize: CGSize) -> PNSuceeded
}
