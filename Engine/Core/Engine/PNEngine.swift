//
//  Copyright © 2021 Mateusz Stompór. All rights reserved.
//

public protocol PNEngine {
    var scene: PNScene { get set }
    var taskQueue: PNRepeatableTaskQueue { get }
    func draw()
    func update(drawableSize: CGSize) -> PNSuceeded
}
