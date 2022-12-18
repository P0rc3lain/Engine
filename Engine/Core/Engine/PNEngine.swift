//
//  Copyright © 2021 Mateusz Stompór. All rights reserved.
//

import CoreGraphics

public protocol PNEngine {
    var scene: PNScene { get set }
    var taskQueue: PNRepeatableTaskQueue { get }
    func draw()
    func update(drawableSize: CGSize) -> PNSuceeded
}
