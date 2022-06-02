//
//  Copyright © 2021 Mateusz Stompór. All rights reserved.
//

public protocol PNEngine {
    var scene: PNScene { get }
    var taskQueue: PNRepeatableTaskQueue { get }
    func draw()
    func update(drawableSize: CGSize) -> Suceeded
}
